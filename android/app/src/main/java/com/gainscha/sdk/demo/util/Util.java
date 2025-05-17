package com.gainscha.sdk.demo.util;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.ColorMatrix;
import android.graphics.ColorMatrixColorFilter;
import android.graphics.Matrix;
import android.graphics.Paint;

/**
 * @author mxlei
 * @date 2021/12/7
 */
public class Util {

    /**
     * 缩放图片
     *
     * @param bitmap    源图片
     * @param dstWidth  目标图宽度
     * @param dstHeight 目标图高度
     * @return 缩放后的图片
     */
    public static Bitmap resizeBitmap(Bitmap bitmap, int dstWidth, int dstHeight) {
        if (bitmap == null) {
            return null;
        }
        if (bitmap.getWidth() == dstWidth && bitmap.getHeight() == dstHeight) {
            return bitmap;
        }
        if (dstWidth < 1 || dstHeight < 1) {
            throw new IllegalArgumentException("Bitmap output width and height must greater than 1");
        }
        float scaleX = ((float) dstWidth) / bitmap.getWidth();
        float scaleY = ((float) dstHeight) / bitmap.getHeight();
        Matrix matrix = new Matrix();
        matrix.postScale(scaleX, scaleY);
        return Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
    }

    public static Bitmap brightnessContrast(Bitmap bmp, float brightness, float contrast) {
        ColorMatrix matrix = new ColorMatrix();
        Paint paint = new Paint();
        Bitmap dst = Bitmap.createBitmap(bmp.getWidth(), bmp.getHeight(), bmp.getConfig());
        Canvas canvas = new Canvas(dst);
        if(contrast > 2f) {
            contrast = 2f;
        }else if(contrast < 0f) {
            contrast = 0f;
        }
        matrix.set(new float[]{
                contrast, 0f, 0f, 0f, brightness,
                0f, contrast, 0f, 0f, brightness,
                0f, 0f, contrast, 0f, brightness,
                0f, 0f, 0f, 1f, 0f
        });
        paint.setColorFilter(new ColorMatrixColorFilter(matrix));
        canvas.drawBitmap(bmp, 0, 0, paint);
        return dst;
    }

    public static Bitmap saturation(Bitmap bitmap, float saturation) {
        ColorMatrix matrix = new ColorMatrix();
        Paint paint = new Paint();
        Bitmap dst = Bitmap.createBitmap(bitmap.getWidth(), bitmap.getHeight(), bitmap.getConfig());
        Canvas canvas = new Canvas(dst);
        matrix.setSaturation(saturation);
        paint.setColorFilter(new ColorMatrixColorFilter(matrix));
        canvas.drawBitmap(bitmap, 0, 0, paint);
        return dst;
    }
}
