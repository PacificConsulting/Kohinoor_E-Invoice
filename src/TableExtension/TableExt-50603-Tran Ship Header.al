tableextension 50603 Trans_ship_Hear_ext extends "Transfer Shipment Header"
{
    fields
    {
        field(50601; "EINV IRN No."; Text[64])
        {
            DataClassification = ToBeClassified;
        }
        field(50602; "EINV QR Code"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(50603; "Cancel Remark"; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(50604; "Cancel IRN No."; Text[64])
        {
            DataClassification = ToBeClassified;
        }
        field(50605; "E-Way Bill Generate"; Option)
        {
            OptionCaption = ' ,To Generate,Generated';
            OptionMembers = " ","To Generate",Generated;

        }
    }

    var
        myInt: Integer;
}