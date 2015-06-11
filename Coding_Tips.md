# Introduction #

Here are some useful coding tips where everybody is welcome to contribute.

# GUIs #

  * Modifying GUIs
    * This is done by using the instruction "guide" from the MATLAB command window. Then open the figure of interest and double click on the desired component, this will open a window to modify its properties. The most common ones are: "String" and "Value".

  * Use "guidata" to save new information in the GUI
    * A simple trick is to add it as part of the "handles" and then use "guidata(hObject,handles)" to save the handles back in the GUI.