pageextension 50604 "Location card E-Inv" extends "Location Card"
{
    layout
    {

        addafter("Tax Information")
        {
            group("E-Invoice Setup")
            {
                field("E-Invoice Applicable"; Rec."E-Invoice Applicable")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-Invoice Applicable field.';
                }
            }
        }
    }
}
