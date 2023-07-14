page 50607 "E-Way List"
{
    ApplicationArea = All;
    Caption = 'E-Way List';
    PageType = List;
    SourceTable = "E-Way Bill Detail";
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
                field("Eway Bill No."; Rec."Eway Bill No.")
                {
                    ToolTip = 'Specifies the value of the Eway Bill No. field.';
                }
                field("E-Way Bill Generate"; Rec."E-Way Bill Generate")
                {
                    ToolTip = 'Specifies the value of the E-Way Bill Generate field.';
                }
                field("Transport Distance"; Rec."Transport Distance")
                {
                    ToolTip = 'Specifies the value of the Transport Distance field.';
                }
                field("Transportation Mode"; Rec."Transportation Mode")
                {
                    ToolTip = 'Specifies the value of the Transportation Mode field.';
                }
                field("Transporter Id"; Rec."Transporter Id")
                {
                    ToolTip = 'Specifies the value of the Transporter Id field.';
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                    ToolTip = 'Specifies the value of the Transporter Name field.';
                }
                field("URL for PDF"; Rec."URL for PDF")
                {
                    ToolTip = 'Specifies the value of the URL for PDF field.';
                }
                field("Ewaybill Error"; Rec."Ewaybill Error")
                {
                    ToolTip = 'Specifies the value of the Ewaybill Error field.';
                }
            }
        }
    }
}
