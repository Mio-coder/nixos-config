{...}: {
  programs.wofi = {
    enable = true;
    style = ''
      * {
          font-family: "DejaVu Sans Mono", monospace; /* Match Sway's default font */
          font-size: 11pt;  /* Slightly smaller font size */
      }

      #window {
          background-color: #2f343f;
          border: 1px solid #555555;
          border-radius: 0; /* Force square corners */
          padding: 2px;     /* Reduced padding */
          margin: 0;
          width: 400px;     /* Narrower default width */
      }

      #input {
          color: #ffffff;
          background-color: #404552;
          border: 0;
          border-bottom: 1px solid #555555;
          padding: 4px 8px;  /* Tighter padding */
          margin: 0;
          border-radius: 0;  /* Remove input field rounding */
      }

      #list {
          color: #ffffff;
          background-color: #2f343f;
          padding: 2px 0;    /* Reduced list padding */
          margin: 0;
          border-radius: 0;  /* Remove list rounding */
      }

      #element {
          color: #ffffff;
          background-color: #2f343f;
          padding: 4px 8px;  /* More compact element padding */
          margin: 0;
          border-radius: 0;  /* Remove element rounding */
      }

      #element.selected {
          background-color: #5294e2;
          color: #ffffff;
      }

      #element-icon {
          margin: 0 4px 0 0;  /* Smaller icon margin */
      }

      /* Scroll and slider adjustments */
      #scroll {
          margin: 0;
          padding: 0;
      }

      #slider {
          background-color: #4c566a;
          border-radius: 0;
      }

      #entry:selected {
          background-color: #4c566a;
      }
    '';
  };
}
