package com.gainscha.sdk.demo.ui;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.view.MenuItem;
import android.view.View;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;

import com.gainscha.fimage.FImage;
import com.gainscha.sdk.demo.util.Constants;
import com.gainscha.sdk.demo.util.Util;
import com.gainscha.sdk2.ConnectionListener;
import com.gainscha.sdk2.Printer;
import com.gainscha.sdk2.PrinterResponse;
import com.gainscha.sdk2.command.Cpcl;
import com.gainscha.sdk2.command.Esc;
import com.gainscha.sdk2.command.EscCommand;
import com.gainscha.sdk2.command.EscForDotPrinter;
import com.gainscha.sdk2.command.Tspl;
import com.gainscha.sdk2.command.Zpl;
import com.gainscha.sdk2.command.zpl.BitmapDataFormat;
import com.gainscha.sdk2.command.zpl.Code128Mode;
import com.gainscha.sdk2.command.zpl.LengthUnit;
import com.gainscha.sdk2.command.zpl.PaperType;
import com.gainscha.sdk2.command.zpl.PrintMode;
import com.gainscha.sdk2.command.zpl.Rotation;
import com.gainscha.sdk2.command.zpl.TextAlignment;
import com.gainscha.sdk2.model.Instruction;
import com.gainscha.sdk2.model.PrinterState;
import com.kinjos.meal.enjoy_meal.R;
import com.kinjos.meal.enjoy_meal.databinding.ActivityPrinterMainBinding;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class PrinterMainActivity extends AppCompatActivity implements Toolbar.OnMenuItemClickListener, ConnectionListener {

    private ActivityPrinterMainBinding binding;
    private Printer printer;
    private LoadingDialog loadingDialog;
    private static final String TAG = "MainActivity";
    private static final int REQ_BITMAP_ADJUST = 100;
    private float brightness = 2f;
    private float gamma = 3.6f;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityPrinterMainBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        loadingDialog = new LoadingDialog(this);
        binding.toolbar.setOnMenuItemClickListener(this);
        //Add printer connection listener
        Printer.addConnectionListener(this);
        if (!Printer.getConnectedPrinters().isEmpty()) {
            printer = Printer.getConnectedPrinters().get(0);
            binding.toolbar.getMenu().getItem(0).setTitle(R.string.connected);
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        //Remove printer connected listener
        Printer.removeConnectionListener(this);
        loadingDialog.dismiss();
    }

    @Override
    public void onPrinterConnected(Printer printer) {
        binding.toolbar.getMenu().getItem(0).setTitle(R.string.connected);
        this.printer = printer;
    }

    @Override
    public void onPrinterConnectFail(Printer printer) {
    }

    @Override
    public void onPrinterDisconnect(Printer printer) {
        binding.toolbar.getMenu().getItem(0).setTitle("搜索全部");
        this.printer = null;
    }

    @Override
    public boolean onMenuItemClick(MenuItem item) {
        if (item.getItemId() == R.id.menu_printer) {
            if (printer != null && printer.isConnected()) {
                //disconnect printer dialog
                new AlertDialog.Builder(this)
                    .setTitle(R.string.disconnect_printer)
                    .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            printer.disconnect();
                        }
                    })
                    .setNegativeButton(android.R.string.cancel, null)
                    .show();
            } else {
                //connect printer
               toSearch(Constants.SearchTypeAll);
            }
        }
        return true;
    }

    private void toSearch(int type){
        Intent intent = new Intent(this, PrinterConnectActivity.class);
        intent.putExtra("type",type);
        startActivity(intent);
    }

    private boolean checkPrinterConnected() {
        if (printer != null && printer.isConnected()) {
            return true;
        } else {
            Toast.makeText(this, R.string.toast_printer_not_connect, Toast.LENGTH_SHORT).show();
        }
        return false;
    }

    public void onClickSearchBle(View view) {
        toSearch(Constants.SearchTypeBle);
    }

    public void onClickSearchUsb(View view) {
        toSearch(Constants.SearchTypeUsb);
    }

    public void onClickSearchSer(View view) {
        toSearch(Constants.SearchTypeSer);
    }

    public void onClickSearchWifi(View view) {
        toSearch(Constants.SearchTypeWifi);
    }

    public void onClickGetPrinterStatus(View view) {
        if (checkPrinterConnected()) {
            printer.getPrinterStatus(Instruction.ESC, new PrinterResponse<PrinterState>() {
                @Override
                public void onPrinterResponse(PrinterState printerState) {
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            Toast.makeText(PrinterMainActivity.this, "status: " + Integer.toHexString(printerState.getStatus()), Toast.LENGTH_SHORT).show();
                        }
                    });
                }
            });
        }
    }

    public void onClickPrintEscImage(View view) {
        if (checkPrinterConnected()) {
            try {
                loadingDialog.show();
                float width = 48 * 8;
                Esc cmd = new Esc();
                cmd.initPrinter();
                cmd.setPrintableWidth((int) width);
                try {
                    String[] fileList = getAssets().list("avatar");
                    for (String file : fileList) {
                        Bitmap bitmap = BitmapFactory.decodeStream(getAssets().open("avatar/" + file));
                        bitmap = Util.resizeBitmap(bitmap, (int) width, (int) (bitmap.getHeight() * width / bitmap.getWidth()));
                        bitmap = FImage.threshold(bitmap, brightness, gamma, true);
                        cmd.addBitmap(bitmap, true);
                        cmd.printAndFeedBackLines(1);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
                printer.print(cmd.getBytes(), null);
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                loadingDialog.dismiss();
            }
        }
    }

    public void onClickPrintEsc(View view) {
        if (checkPrinterConnected()) {
            try {
                loadingDialog.show();
                EscCommand esc = new EscCommand();
                esc.addInitializePrinter();
                Bitmap bitmap = BitmapFactory.decodeStream(getAssets().open("avatar/test1.png"));
                bitmap = Util.resizeBitmap(bitmap, 400, (int) (bitmap.getHeight() * 400f / bitmap.getWidth()));
                esc.addBitmap(bitmap, bitmap.getWidth(),true);
                esc.addPrintAndLineFeed();
                Bitmap bitmap1 = BitmapFactory.decodeStream(getAssets().open("avatar/test2.png"));
                bitmap1 = Util.resizeBitmap(bitmap1, 400, (int) (bitmap1.getHeight() * 400f / bitmap1.getWidth()));
                esc.addBitmap(bitmap1, bitmap1.getWidth(),false);
                esc.addPrintAndLineFeed();
                Bitmap bitmap2 = BitmapFactory.decodeStream(getAssets().open("avatar/test3.jpg"));
                bitmap2 = Util.resizeBitmap(bitmap2, 400, (int) (bitmap2.getHeight() * 400f / bitmap2.getWidth()));
                esc.addBitmap(bitmap2, bitmap2.getWidth(),false);
                esc.addPrintAndLineFeed();
                esc.addPrintAndLineFeed();
                printer.print(esc.getBytes(), null);
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                loadingDialog.dismiss();
            }
        }
    }

    public void onClickPrintEscDot(View view) {
        if (checkPrinterConnected()) {
            try {
                loadingDialog.show();
                EscForDotPrinter esc = new EscForDotPrinter();
                esc.initPrinter();
                esc.setTextFont(Esc.TEXT_FONT_KANJI);
                esc.addText("小票打印\n");
                esc.addText("放大字体\n");
                esc.addBarcode(Esc.BARCODE_EAN8,100,50,true,15,"454546546");
                esc.addQrcode(100,100,"sdfsdfsdfsdf");
                Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.keai);
                bitmap = Util.resizeBitmap(bitmap, 400, (int) (bitmap.getHeight() * 400f / bitmap.getWidth()));
                esc.addBitmap(bitmap, true);
                esc.printAndFeedBackLines(1);
                printer.print(esc.getBytes(), null);
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                loadingDialog.dismiss();
            }
        }
    }

    public void onClickPrintZpl(View view) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:SS");
        int x = 0;
        int y = 0;
        Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.man);
        bitmap = Util.resizeBitmap(bitmap, 640, (int) (bitmap.getHeight() * 640f / bitmap.getWidth()));
        Zpl zpl = new Zpl();
        zpl.pageBegin()
            //标签大小
            .setSize(80 * 12, 2400)
            //打印后清除内容
            .setCleanUpAfterPrint(true)
            //水平镜像
            .setHorizontalMirror(false)
            //反向出纸
            .setVerticalReverse(false)
            //标签偏移
            .setOffset(0, 0)
            //撕纸偏移
            .setTearOffset(0)
            //打印速度
            .setSpeed(3)
            //打印浓度
            .setDensity(10)
            //文本对齐和旋转
            .setTextAlignAndRotation(Rotation.ROTATE_0, TextAlignment.LEFT)
            //纸张类型
            .setPaperType(PaperType.CONTINUOUS, 0)
            //打印模式：热敏
            .setPrintMode(PrintMode.DIRECT_THERMAL)
            //全局长度单位：点
            .setGlobalLengthUnit(LengthUnit.DOT)
            .addFieldSeparator()
            //设置默认字体
            .setDefaultFont('0', 30, 40)
            //设置字体
            .setFont('0', Rotation.ROTATE_0, 120, 80)
            .moveTo(x, y).addText("ZPL command test")
            .moveTo(x, y += 80).addText(dateFormat.format(new Date()))
            .moveTo(x, y += 80).setFont('0', Rotation.ROTATE_0, 60, 80).addText("font 0")
            .moveTo(x, y += 80).setFont('1', Rotation.ROTATE_0, 30, 40).addText("font 1")
            .moveTo(x, y += 80).setFont('0', Rotation.ROTATE_90, 60, 80).addText("rotate 90")
            .moveTo(x, y += 80).setFont('0', Rotation.ROTATE_180, 60, 80).addText("rotate 180")
            .moveTo(x, y += 80).addBarcode128(Rotation.ROTATE_0,
                80,
                true,
                false,
                true,
                Code128Mode.AUTO,
                "hello code128")
            .moveTo(x, y += 100).addBarcodeAztec(Rotation.ROTATE_0,
                10,
                false,
                2,
                false,
                1,
                "0",
                "gainscha")
            .moveTo(x, y += 200).addBarcode11(
                Rotation.ROTATE_0,
                80,
                true,
                false,
                true,
                "123456")
            .moveTo(x, y += 80).addBarcode39(Rotation.ROTATE_0,
                80,
                true,
                false,
                true,
                "123456")
            .moveTo(x, y += 80).addBarcodeEAN13(Rotation.ROTATE_0,
                80,
                true,
                false,
                "123456789123")
            .moveTo(x, y += 120).addLine(400, 1)
            .moveTo(x, y += 20).addBox(400, 80, 1, false, 5)
            .moveTo(x, y += 100).addBox(400, 80, 1, true, 5)
            .moveTo(x, y += 200)
            .addBitmap(bitmap, BitmapDataFormat.ASCII, true)
            .setPrintCount(1)
            .pageEnd();
        if (checkPrinterConnected()) {
            try {
                printer.print(zpl.getBytes());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void onClickPrintCpcl(View view) {
        if (checkPrinterConnected()) {
            Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.man);
            int width = 480;
            int height = (int) (bitmap.getHeight() * ((float) width) / bitmap.getWidth());
            bitmap = Util.resizeBitmap(bitmap, width, height);

            Cpcl cmd = new Cpcl();
            cmd.addInitializePrinter(0, bitmap.getHeight(), 1);
            cmd.addPagewidth(bitmap.getWidth());
            cmd.addJustification(Cpcl.ALIGNMENT.CENTER);
            cmd.addBitmap(0, 0, bitmap, false, true);
            cmd.addPrint();
            byte[] bytes = cmd.getBytes();
            try {
                printer.print(bytes);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void onClickPrintTspl(View view) {
        if (checkPrinterConnected()) {
            Tspl cmd = new Tspl();
            int y = 0;
            //set label size
            cmd.addSize(60, 120);
            //clear buffer
            cmd.addCls();
            //add text
            cmd.addText(0, y, Tspl.FONT_TSS24, 0, 1, 1, "This is text.");
            y += 30;
            //add text by bitmap
            cmd.addTextByBitmap(0, y, 0, 36, "8888888", null);
            y += 50;
            //barcode
            cmd.add1DBarcode(0, y, Tspl.BARCODE_CODE_128, 60, true, 0, "12345678");
            y += 90;
            //qrcode
            cmd.addQRCode(0, y, Tspl.BARCODE_ERROR_LEVEL_MEDIUM, 5, 0, "This is a qrcode");
            y += 150;
            //line
            cmd.addBar(0, y, 400, 2);
            y += 20;
            //rectangle
            cmd.addBox(0, y, 400, y + 60, 2);
            y += 80;
            //bitmap

            Bitmap bitmap = BitmapFactory.decodeResource(getResources(), R.drawable.keai);
            bitmap = Util.resizeBitmap(bitmap, 400, (int) (bitmap.getHeight() * 400f / bitmap.getWidth()));
            cmd.addBitmap(0, y, bitmap, bitmap.getWidth(), Tspl.BITMAP_MODE.OVERWRITE, true);
            //print count
            cmd.addPrint(1);
            byte[] data = cmd.getBytes();
            try {
                printer.print(data);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

}