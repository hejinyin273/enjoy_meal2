package com.gainscha.sdk.demo.ui;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AlertDialog;

import com.kinjos.meal.enjoy_meal.R;


public class LoadingDialog extends AlertDialog {

    protected LoadingDialog(@NonNull Context context) {
        super(context);
        View view = LayoutInflater.from(context).inflate(R.layout.dialog_loading, null, false);
        setCancelable(false);
        setCanceledOnTouchOutside(false);
        setView(view);
    }
}
