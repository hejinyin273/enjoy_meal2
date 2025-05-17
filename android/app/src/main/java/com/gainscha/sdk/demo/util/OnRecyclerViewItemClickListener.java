package com.gainscha.sdk.demo.util;

import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.core.view.GestureDetectorCompat;
import androidx.recyclerview.widget.RecyclerView;

/**
 * @author mxlei
 * @date 2021/7/2
 */
public abstract class OnRecyclerViewItemClickListener implements RecyclerView.OnItemTouchListener {

    private final GestureDetectorCompat gestureDetector;

    public OnRecyclerViewItemClickListener(RecyclerView recyclerView) {
        this.gestureDetector = new GestureDetectorCompat(recyclerView.getContext(), new GestureDetector.SimpleOnGestureListener() {

            @Override
            public boolean onSingleTapUp(MotionEvent e) {
                View child = recyclerView.findChildViewUnder(e.getX(), e.getY());
                if (child != null) {
                    RecyclerView.ViewHolder viewHolder = recyclerView.getChildViewHolder(child);
                    int position = recyclerView.getChildLayoutPosition(child);
                    onItemClick(viewHolder, position);
                }
                return true;
            }

            @Override
            public void onLongPress(MotionEvent e) {
                super.onLongPress(e);
                View child = recyclerView.findChildViewUnder(e.getX(), e.getY());
                if (child != null) {
                    RecyclerView.ViewHolder viewHolder = recyclerView.getChildViewHolder(child);
                    int position = recyclerView.getChildLayoutPosition(child);
                    onItemLongClick(viewHolder, position);
                }
            }
        });
    }

    @Override
    public boolean onInterceptTouchEvent(@NonNull RecyclerView rv, @NonNull MotionEvent e) {
        gestureDetector.onTouchEvent(e);
        return false;
    }

    @Override
    public void onTouchEvent(@NonNull RecyclerView rv, @NonNull MotionEvent e) {
        gestureDetector.onTouchEvent(e);
    }

    @Override
    public void onRequestDisallowInterceptTouchEvent(boolean disallowIntercept) {

    }

    protected abstract void onItemClick(RecyclerView.ViewHolder vh, int position);

    void onItemLongClick(RecyclerView.ViewHolder vh, int position) {
    }
}
