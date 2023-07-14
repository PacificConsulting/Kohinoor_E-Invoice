page 50606 "E-Invoice List"
{
    ApplicationArea = All;
    Caption = 'E-Invoice List';
    PageType = List;
    SourceTable = "E-Invoice Detail";
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("E-Invoice IRN No."; Rec."E-Invoice IRN No.")
                {
                    ToolTip = 'Specifies the value of the E-Invoice IRN No. field.';
                }
                field("E-Invoice Acknowledg No."; Rec."E-Invoice Acknowledg No.")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Acknowledg No. field.';
                }
                field("E-Invoice QR Code"; Rec."E-Invoice QR Code")
                {
                    ToolTip = 'Specifies the value of the E-Invoice QR Code field.';
                }
                field("E-Invoice Acknowledg Date Time"; Rec."E-Invoice Acknowledg Date Time")
                {
                    ToolTip = 'Specifies the value of the E-Invoice Acknowledg Date Time field.';
                }
                field("URL for PDF"; Rec."URL for PDF")
                {
                    ToolTip = 'Specifies the value of the URL for PDF field.';
                }
            }
        }
    }
}
