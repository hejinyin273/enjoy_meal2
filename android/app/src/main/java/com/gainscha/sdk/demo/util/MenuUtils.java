package com.gainscha.sdk.demo.util;

import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

public class MenuUtils {
    public static String TAG = MenuUtils.class.getSimpleName();
    private static final int LINE_BYTE_SIZE = 48;
    private static final int LEFT_LENGTH = 30;
    private static final int CENTER_LENGTH = 8;
    private static final int RIGHT_LENGTH = 10;
    private static final int FIRST_PIECE = 24;
    private static final int SECOND_PIECE = 8;
    private static final int THIRD_PIECE = 7;
    private static final int FOURTH_PIECE = 9;

    public MenuUtils() {
    }

    public static String printTwoData(String leftText, String rightText) {
        StringBuilder sb = new StringBuilder();
        int leftTextLength = getBytesLength(leftText);
        int rightTextLength = getBytesLength(rightText);
        sb.append(leftText);
        int marginBetweenMiddleAndRight = 48 - leftTextLength - rightTextLength;

        for(int i = 0; i < marginBetweenMiddleAndRight; ++i) {
            sb.append(" ");
        }

        sb.append(rightText);
        return sb.toString() + "\n";
    }

    public static String printThreeData(String leftText, String middleText, String rightText) {
        StringBuilder sb = new StringBuilder();
        String str = "";
        List<String> list = getStrList(leftText, 15);

        int i;
        for(i = 0; i < list.size(); ++i) {
            if (i == 0) {
                leftText = (String)list.get(i);
            } else {
                str = str + (String)list.get(i) + "\n";
            }
        }

        i = getBytesLength(leftText);
        int middleTextLength = getBytesLength(middleText);
        int rightTextLength = getBytesLength(rightText);
        sb.append(leftText);
        int leftSpace = 30 - i;

        int centerSpace;
        for(centerSpace = 0; centerSpace < leftSpace; ++centerSpace) {
            sb.append(" ");
        }

        centerSpace = 8 - middleTextLength;

        int rightSpace;
        for(rightSpace = 0; rightSpace < centerSpace; ++rightSpace) {
            sb.append(" ");
        }

        sb.append(middleText);
        rightSpace = 10 - rightTextLength;

        for(int k = 0; k < rightSpace; ++k) {
            sb.append(" ");
        }

        sb.append(rightText);
        return sb.toString() + "\n" + str;
    }

    public static String printFourData(String oneText, String twoText, String threeText, String fourText) {
        StringBuilder sb = new StringBuilder();
        String str = "";
        List<String> list = getStrList(oneText, 12);

        int i;
        for(i = 0; i < list.size(); ++i) {
            if (i == 0) {
                oneText = (String)list.get(i);
            } else {
                str = str + (String)list.get(i) + "\n";
            }
        }

        i = getBytesLength(oneText);
        int twoTextLength = getBytesLength(twoText);
        int threeTextLength = getBytesLength(threeText);
        int fourTextLength = getBytesLength(fourText);
        sb.append(oneText);
        int oneSpace = 24 - i;

        int twoSpace;
        for(twoSpace = 0; twoSpace < oneSpace; ++twoSpace) {
            sb.append(" ");
        }

        twoSpace = 8 - twoTextLength;

        int threeSpace;
        for(threeSpace = 0; threeSpace < twoSpace; ++threeSpace) {
            sb.append(" ");
        }

        sb.append(twoText);
        threeSpace = 7 - threeTextLength;

        int fourSpace;
        for(fourSpace = 0; fourSpace < threeSpace; ++fourSpace) {
            sb.append(" ");
        }

        sb.append(threeText);
        fourSpace = 9 - fourTextLength;

        for(int k = 0; k < fourSpace; ++k) {
            sb.append(" ");
        }

        sb.append(fourText);
        return sb.toString() + "\n" + str;
    }

    private static int getBytesLength(String msg) {
        return msg.getBytes(Charset.forName("GB18030")).length;
    }

    public static List<String> getStrList(String inputString, int length) {
        int size = inputString.length() / length;
        if (inputString.length() % length != 0) {
            ++size;
        }

        return getStrList(inputString, length, size);
    }

    public static List<String> getStrList(String inputString, int length, int size) {
        List<String> list = new ArrayList();

        for(int index = 0; index < size; ++index) {
            String childStr = substring(inputString, index * length, (index + 1) * length);
            list.add(childStr);
        }

        return list;
    }

    public static String substring(String str, int f, int t) {
        if (f > str.length()) {
            return null;
        } else {
            return t > str.length() ? str.substring(f, str.length()) : str.substring(f, t);
        }
    }
}
