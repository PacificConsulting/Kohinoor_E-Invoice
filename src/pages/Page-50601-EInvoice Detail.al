page 50601 "E-Invoice Detail"
{
    // version PCPL41-EINV
    PageType = ListPart;
    SourceTable = 50601;
    //ApplicationArea = all;
    UsageCategory = Lists;
    Editable = false;
    Caption = 'E-Invoice Detail';

    layout
    {
        area(content)
        {

            field("E-Invoice IRN No."; rec."E-Invoice IRN No.")
            {
                ApplicationArea = all;
            }
            field("E-Invoice QR Code"; rec."E-Invoice QR Code")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("URL for PDF"; rec."URL for PDF")
            {
                ApplicationArea = all;

            }
            field("E-Invoice Acknowledg No."; Rec."E-Invoice Acknowledg No.")
            {
                ApplicationArea = all;
            }
            field("E-Invoice Acknowledg Date Time"; Rec."E-Invoice Acknowledg Date Time")
            {
                ApplicationArea = all;
            }
            field("Cancel Remark"; rec."Cancel Remark")
            {
                ApplicationArea = all;
            }
            field("Cancel IRN No."; rec."Cancel IRN No.")
            {
                ApplicationArea = all;
            }


        }
    }

    actions
    {
    }
}

