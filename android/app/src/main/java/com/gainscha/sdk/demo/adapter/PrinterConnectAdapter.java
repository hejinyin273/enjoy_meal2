package com.gainscha.sdk.demo.adapter;

import android.view.LayoutInflater;
import android.view.ViewGroup;

import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;


import com.gainscha.sdk2.model.PrinterDevice;
import com.kinjos.meal.enjoy_meal.databinding.ListItemPrinterBinding;

import java.util.ArrayList;
import java.util.List;

public class PrinterConnectAdapter extends RecyclerView.Adapter<PrinterConnectAdapter.Holder> {

    private final List<PrinterDevice> items = new ArrayList<>();

    static class Holder extends RecyclerView.ViewHolder {
        private final ListItemPrinterBinding binding;

        public Holder(@NonNull ListItemPrinterBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }
    }

    public void addItem(PrinterDevice item) {
        items.add(item);
        notifyItemInserted(items.size() - 1);
    }

    public PrinterDevice getItem(int position) {
        if (position >= 0 && position < items.size()) {
            return items.get(position);
        }
        return null;
    }

    @NonNull
    @Override
    public Holder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new Holder(ListItemPrinterBinding.inflate(LayoutInflater.from(parent.getContext()), parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull Holder holder, int position) {
        holder.binding.name.setText(items.get(position).getPrinterName());
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

}
