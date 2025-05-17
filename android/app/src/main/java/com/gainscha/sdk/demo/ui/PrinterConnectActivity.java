package com.gainscha.sdk.demo.ui;

import android.Manifest;
import android.content.pm.PackageManager;
import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import com.gainscha.sdk.demo.adapter.PrinterConnectAdapter;
import com.gainscha.sdk.demo.util.Constants;
import com.gainscha.sdk.demo.util.OnRecyclerViewItemClickListener;
import com.gainscha.sdk2.ConnectionListener;
import com.gainscha.sdk2.Printer;
import com.gainscha.sdk2.PrinterFinder;
import com.gainscha.sdk2.model.BluetoothPrinterDevice;
import com.gainscha.sdk2.model.PrinterDevice;
import com.gainscha.sdk2.model.SerialPortPrinterDevice;
import com.gainscha.sdk2.model.UsbAccessoryPrinterDevice;
import com.gainscha.sdk2.model.UsbPrinterDevice;
import com.gainscha.sdk2.model.WifiPrinterDevice;
import com.kinjos.meal.enjoy_meal.databinding.ActivityPrinterConnectBinding;

public class PrinterConnectActivity extends AppCompatActivity implements PrinterFinder.SearchPrinterResultListener, ConnectionListener {

    private final PrinterFinder finder = new PrinterFinder();
    private ActivityPrinterConnectBinding binding;
    private PrinterConnectAdapter adapter;
    private LoadingDialog loadingDialog;

    private int type = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        type = getIntent().getIntExtra("type", 0);
        adapter = new PrinterConnectAdapter();
        loadingDialog = new LoadingDialog(this);
        binding = ActivityPrinterConnectBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        binding.toolbar.setNavigationOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        binding.recyclerview.setLayoutManager(new LinearLayoutManager(this));
        binding.recyclerview.setAdapter(adapter);
        binding.recyclerview.addOnItemTouchListener(new OnRecyclerViewItemClickListener(binding.recyclerview) {
            @Override
            protected void onItemClick(RecyclerView.ViewHolder vh, int position) {
                loadingDialog.show();
                PrinterDevice printerDevice = adapter.getItem(position);
                // connect printer
                Printer.connect(printerDevice);
            }
        });
        // add printer connection listener
        Printer.addConnectionListener(this);
        // find printer devices(bluetooth wifi usb serial_port)

        if (checkBluetoothPermission()) {
            finder.searchPrinters(this);
        }
    }

    private boolean checkBluetoothPermission() {
        String[] pms;
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return true;
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            pms = new String[]{
                    Manifest.permission.BLUETOOTH_SCAN,
                    Manifest.permission.BLUETOOTH_CONNECT,
                    Manifest.permission.ACCESS_FINE_LOCATION
            };
        } else {
            pms = new String[]{
                    Manifest.permission.BLUETOOTH,
                    Manifest.permission.ACCESS_FINE_LOCATION
            };
        }
        for (String pm : pms) {
            if (checkSelfPermission(pm) != PackageManager.PERMISSION_GRANTED) {
                requestPermissions(pms, 100);
                return false;
            }
        }
        return true;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        if (requestCode == 100) {
            boolean grantAll = true;
            for (int r : grantResults) {
                if (r != PackageManager.PERMISSION_GRANTED) {
                    grantAll = false;
                    break;
                }
            }
            if (grantAll) {
                finder.searchPrinters(this);
            }
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        // stop find printer device
        finder.stopSearchDevice();
        // remove printer connection listener
        Printer.removeConnectionListener(this);
    }

    @Override
    public void onSearchBluetoothPrinter(BluetoothPrinterDevice device) {
        if (type != Constants.SearchTypeBle && type != Constants.SearchTypeAll) return;
        adapter.addItem(device);
    }

    @Override
    public void onSearchUsbPrinter(UsbPrinterDevice device) {
        if (type != Constants.SearchTypeUsb && type != Constants.SearchTypeAll) return;
        adapter.addItem(device);
    }

    @Override
    public void onSearchUsbPrinter(UsbAccessoryPrinterDevice device) {
        if (type != Constants.SearchTypeUsb && type != Constants.SearchTypeAll) return;
        adapter.addItem(device);
    }

    @Override
    public void onSearchNetworkPrinter(WifiPrinterDevice device) {
        if (type != Constants.SearchTypeWifi && type != Constants.SearchTypeAll) return;
        adapter.addItem(device);
    }

    @Override
    public void onSearchSerialPortPrinter(SerialPortPrinterDevice device) {
        if (type != Constants.SearchTypeSer && type != Constants.SearchTypeAll) return;
        adapter.addItem(device);
    }

    @Override
    public void onSearchCompleted() {

    }

    @Override
    public void onPrinterConnected(Printer printer) {
        loadingDialog.dismiss();
        finish();
        Toast.makeText(this, "连接成功", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onPrinterConnectFail(Printer printer) {
        loadingDialog.dismiss();
        Toast.makeText(this, "连接失败", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onPrinterDisconnect(Printer printer) {
        loadingDialog.dismiss();
        Toast.makeText(this, "连接断开", Toast.LENGTH_SHORT).show();
    }

}