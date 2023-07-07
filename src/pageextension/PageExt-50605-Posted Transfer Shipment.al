pageextension 50605 Posted_Tra_ship_ext extends "Posted Transfer Shipment"
{
    layout
    {

        modify("Shipping Agent Code")
        {
            Editable = true;
            trigger OnAfterValidate()
            var
                ShipAgent: Record "Shipping Agent";
            begin
                // IF ShipAgent.GET("Shipping Agent Code") then begin
                //     "Transport Vendor" := Shipagent.Name;
                // end

            end;
        }

        // modify("GST E-Invoice1")
        // {
        //     Visible = false;
        // }
        // modify("E-Invoice Error Remarks")
        // {
        //     Visible = false;
        // }
        // modify("E-Way Bill No.")
        // {
        //     Visible = false;

        // }

        addafter(General)
        {
            group("Einvoice Details")
            {
                part("E-Invoice Detail"; "E-Invoice Detail")
                {
                    SubPageLink = "Document No." = FIELD("No.");
                    ApplicationArea = all;
                }
                group("E-Way Bill Details")
                {
                    part("E-Way Bill Detail"; "E-Way Bill Detail")
                    {
                        ApplicationArea = all;
                        SubPageLink = "Document No." = field("No.");

                    }
                }
                // group("E-way Bill Data")
                // {
                //     field("E-Way Bill Generate"; "E-Way Bill Generate")
                //     {
                //         ApplicationArea = all;
                //         Visible = false;
                //     }
                // }

            }
        }
    }

    actions
    {

        addafter(Dimensions)
        {
            action("Generate E-Way Bill")
            {
                Enabled = EWAYGEN;
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Caption = 'Generate E-Way Bill';
                trigger OnAction();
                var
                    SalesPost: Codeunit 80;
                    TSH: Record "Transfer Shipment Header";
                begin
                    //PCPL41-EWAY
                    IF NOT CONFIRM('Do you want generate E-Way Bill?') THEN
                        EXIT;
                    TSH.Reset();
                    TSH.SetRange(TSH."No.", Rec."No.");
                    IF TSH.FindFirst() then begin
                        Rec."E-Way Bill Generate" := Rec."E-Way Bill Generate"::"To Generate";
                        Rec.Modify();
                    end;
                    IF Rec."E-Way Bill Generate" = Rec."E-Way Bill Generate"::"To Generate" THEN
                        EWayBillGenerate
                    ELSE
                        ERROR('E-way Bill Generate should be "To Generate".');
                    //PCPL41-EWAY


                end;
            }
            /*action("E-way")
            {
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Caption = 'E-Way Bill';
                trigger OnAction()
                var

                begin
                    //<<PCPL-0064
                    RecEwayBill.Reset();
                    RecEwayBill.SetRange("Document No.", "No.");
                    //RecEwayBill.SetFilter("Eway Bill No.", '%1', '');
                    if RecEwayBill.FindFirst then begin
                        "E-Way Bill No." := RecEwayBill."Eway Bill No.";
                        Modify();

                    end;
                    //>>PCPL-0064
                end;

            }*/

        }
    }
    //}

    trigger OnOpenPage()
    var
        EWayBillDetailNew: Record 50602;
        EInvoiceDetailNew: record 50601;
    begin
        EWayBillDetailNew.RESET;
        EWayBillDetailNew.SETRANGE("Document No.", Rec."No.");
        EWayBillDetailNew.SETFILTER("Eway Bill No.", '<>%1', '');
        IF EWayBillDetailNew.FINDFIRST THEN BEGIN
            EWAYGEN := FALSE;
        END ELSE
            EWAYGEN := TRUE;
        //PCPL0017-EWAY



    end;

    trigger OnAfterGetRecord()
    var
        EWayBillDetailNew: Record 50602;
    Begin

        EWayBillDetailNew.RESET;
        EWayBillDetailNew.SETRANGE("Document No.", Rec."No.");
        EWayBillDetailNew.SETFILTER("Eway Bill No.", '<>%1', '');
        IF EWayBillDetailNew.FINDFIRST THEN BEGIN
            EWAYGEN := FALSE;
        END ELSE
            EWAYGEN := TRUE;

        // //<<PCPL-0064
        // RecEwayBill.Reset();
        // RecEwayBill.SetRange("Document No.", Rec."No.");
        // //RecEwayBill.SetFilter("Eway Bill No.", '%1', '');
        // if RecEwayBill.FindFirst then begin
        //     Rec."E-Way Bill No." := RecEwayBill."Eway Bill No.";
        //     Modify();

        // end;
        // //>>PCPL-0064


    End;

    var
        EINVGenerate: Boolean;
        EINVCancel: Boolean;
        EWAYGEN: Boolean;
        RecEwayBill: Record "E-Way Bill Detail";




    procedure EWayBillGenerate();
    var
        Headerdata: Text;
        Linedata: Text;
        Location_: Record 14;
        State_: Record State;
        StateCust: Record State;
        HSNSAN: Record "HSN/SAC";
        ShipQty: Decimal;
        cnt: Integer;
        Item_: Record 27;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        IGSTAmt: Decimal;
        CESSGSTAmt: Integer;
        IgstRate: Decimal;
        TotalIGSTAmt: Decimal;
        Document_Date: Text;
        UOMeasure: Text;
        FromGST: Text;
        ToGST: Text;
        TotalTaxableAmt: Decimal;
        LineTaxableAmt: Decimal;
        LineInvoiceAmt: Decimal;
        Supply: Text;
        Subsupply: Text;
        SubSupplydescr: Text;
        PathText: Text;
        UomValue: Text;
        DocumentType: Text;
        GeneralLedgerSetup: Record 98;
        recToLoc: Record 14;
        TransferShipmentLine: Record 5745;
        TotaltaxableAmt1: Text;
        TotaltaxableAmt1Total: Decimal;
        // Ewaybill: DotNet Ewaybillcontroller;
        token: Text;
        result: Text;
        TotalInvAmt: Decimal;
        UOM: Text;
        //<<PCPL/NSW/EINV 052522
        TaxRecordIDEWAY: RecordId;
        TCSAMTLinewiseEWAY: Decimal;
        GSTBaseAmtLineWiseEWAY: Decimal;
        ComponentJobjectEWAY: JsonObject;
        EWayBillDetail: Record 50602;
        TranShipLine: Record "Transfer Shipment Line";
        resresult: Text;
        resresult1: Text;
        resresult2: Text;
        TraShipHeader: Record "Transfer Shipment Header";
    //>>PCPL/NSW/EINV 052522


    begin
        //PCPL41-EWAY
        IF Location_.GET(Rec."Transfer-from Code") THEN;
        IF State_.GET(Location_."State Code") THEN;
        IF recToLoc.GET(Rec."Transfer-to Code") THEN;
        IF StateCust.GET(recToLoc."State Code") THEN;

        TotalIGSTAmt := 0;
        TotalTaxableAmt := 0;
        cnt := 0;
        Linedata := '[';
        // HSNSAN.RESET;
        // HSNSAN.SETCURRENTKEY("GST Group Code", Code);
        // IF HSNSAN.FINDSET THEN
        //         REPEAT
        IGSTAmt := 0;
        ShipQty := 0;
        IgstRate := 0;
        Clear(TotaltaxableAmt1Total);
        TransferShipmentLine.RESET;
        TransferShipmentLine.SETCURRENTKEY("Document No.", "Line No.");
        TransferShipmentLine.SETRANGE("Document No.", Rec."No.");
        //TransferShipmentLine.SETRANGE("HSN/SAC Code", HSNSAN.Code);
        //TransferShipmentLine.SETRANGE("GST Group Code", HSNSAN."GST Group Code");
        IF TransferShipmentLine.FINDSET THEN
            REPEAT
                DetailedGSTLedgerEntry.RESET;
                DetailedGSTLedgerEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                DetailedGSTLedgerEntry.SETRANGE("Document No.", TransferShipmentLine."Document No.");
                DetailedGSTLedgerEntry.SETRANGE("Document Line No.", TransferShipmentLine."Line No.");
                IF DetailedGSTLedgerEntry.FINDSET THEN
                    REPEAT
                        IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN
                            IGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                            IgstRate := DetailedGSTLedgerEntry."GST %";
                            Supply := 'Outward';
                            Subsupply := 'Supply';
                        END;
                    UNTIL DetailedGSTLedgerEntry.NEXT = 0;
                /*
                IF TransferShipmentLine."Unit of Measure Code" = 'PAIR' THEN
                  UomValue := 'PRS'
                ELSE
                  UomValue := 'PCS';
                */
                TotalIGSTAmt += IGSTAmt;

                //<<PCPL/NSW/EINV 052522
                if TranShipLine.Get(TransferShipmentLine."Document No.", TransferShipmentLine."Line No.") then
                    TaxRecordIDEWAY := TransferShipmentLine.RecordId();
                TCSAMTLinewiseEWAY := GetTcsAmtLineWise(TaxRecordIDEWAY, ComponentJobjectEWAY);
                GSTBaseAmtLineWiseEWAY := GetGSTBaseAmtLineWise(TaxRecordIDEWAY, ComponentJobjectEWAY);
                //>>PCPL/NSW/EINV 052522

                //IF TransferShipmentLine."GST Base Amount" = 0 THEN BEGIN
                //clear(TotalTaxableAmt);
                IF (GSTBaseAmtLineWiseEWAY = 0) THEN BEGIN //PCPL/NSW/EINV 052522  New Code added
                    TotalTaxableAmt := TransferShipmentLine.Amount;
                    TotalInvAmt += TransferShipmentLine.Amount + IGSTAmt;
                    DocumentType := 'Delivery Challan';
                    Supply := 'Outward';
                    Subsupply := 'Others';
                    SubSupplydescr := 'Others';
                END ELSE BEGIN
                    TotalTaxableAmt += GSTBaseAmtLineWiseEWAY;//TransferShipmentLine."GST Base Amount"; 
                    TotalInvAmt += GSTBaseAmtLineWiseEWAY + IGSTAmt;
                    DocumentType := 'Tax Invoice';
                    Supply := 'Outward';
                    Subsupply := 'Supply';
                END;

                IF Item_.GET(TransferShipmentLine."Item No.") THEN;

                //  UNTIL TransferShipmentLine.NEXT = 0;

                IF TotalTaxableAmt > 1000 THEN
                    TotaltaxableAmt1 := DELCHR(FORMAT(TotalTaxableAmt), '=', ',');

                TotaltaxableAmt1Total += TotaltaxableAmt;

                IF TransferShipmentLine."Unit of Measure Code" = 'PKT' THEN
                    UOM := 'PAC'
                ELSE
                    UOM := TransferShipmentLine."Unit of Measure Code";

                cnt += 1;
                IF cnt = 1 THEN
                    Linedata += '{"product_name":"' + Item_.Description + '","product_description":"' + Item_.Description + '","hsn_code":"' +
                    TransferShipmentLine."HSN/SAC Code" + '","quantity":"' + FORMAT(TransferShipmentLine.Quantity) + '","unit_of_product":"' + UOM + '","cgst_rate":"' + '0' +
                    '","sgst_rate":"' + '0' + '","igst_rate":"' + FORMAT(IgstRate) + '","cess_rate":"' + '0' + '","cessNonAdvol":"' + '0' +
                    '","taxable_amount":"' + FORMAT(TotaltaxableAmt1) + '"}'
                ELSE
                    Linedata += ',{"product_name":"' + Item_.Description + '","product_description":"' + Item_.Description + '","hsn_code":"' +
                    TransferShipmentLine."HSN/SAC Code" + '","quantity":"' + FORMAT(TransferShipmentLine.Quantity) + '","unit_of_product":"' + UOM + '","cgst_rate":"' + '0' +
                    '","sgst_rate":"' + '0' + '","igst_rate":"' + FORMAT(IgstRate) + '","cess_rate":"' + '0' + '","cessNonAdvol":"' + '0' +
                    '","taxable_amount":"' + FORMAT(TotaltaxableAmt1) + '"}';

            // UNTIL HSNSAN.NEXT = 0;
            UNTIL TransferShipmentLine.NEXT = 0;

        Linedata := Linedata + ']';

        GeneralLedgerSetup.GET;
        /*
        Ewaybill := Ewaybill.eWaybillController;
        token := Ewaybill.GetToken(GeneralLedgerSetup."EINV Base URL", GeneralLedgerSetup."EINV User Name", GeneralLedgerSetup."EINV Password",
        GeneralLedgerSetup."EINV Client ID", GeneralLedgerSetup."EINV Client Secret", GeneralLedgerSetup."EINV Grant Type", GeneralLedgerSetup."EINV Path");
        */
        IF EWayBillDetail.GET(Rec."No.") then;
        //token := Ewaybill.GetToken('https://clientbasic.mastersindia.co', 'testeway@mastersindia.co', 'Test@1234',
        //'fIXefFyxGNfDWOcCWn', 'QFd6dZvCGqckabKxTapfZgJc', 'password');
        //Original code Comment for Test DB for Testing Purpose

        Document_Date := FORMAT(Rec."Posting Date", 0, '<Day,2>/<Month,2>/<year4>');
        Headerdata := '{"access_token":"' + token + '","userGstin":"' + Location_."GST Registration No." + '","supply_type":"' + Supply + '","sub_supply_type":"' + Subsupply +
        '","sub_supply_description":"' + SubSupplydescr + '","document_type":"' + DocumentType + '","document_number":"' + Rec."No." +
        '","document_date":"' + Document_Date + '","gstin_of_consignor":"' + Location_."GST Registration No." + '","legal_name_of_consignor":"' + Location_.Name +
        '","address1_of_consignor":"' + Location_.Address + '","address2_of_consignor":"' + Location_."Address 2" + '","place_of_consignor":"' +
        Location_.City + '","pincode_of_consignor":"' + Location_."Post Code" + '","state_of_consignor":"' + State_.Description +
        '","actual_from_state_name":"' + State_.Description + '","gstin_of_consignee":"' + recToLoc."GST Registration No." + '","legal_name_of_consignee":"' + recToLoc.Name +
        '","address1_of_consignee":"' + recToLoc.Address + '","address2_of_consignee":"' + recToLoc."Address 2" +
        '","place_of_consignee":"' + recToLoc.City + '","pincode_of_consignee":"' + recToLoc."Post Code" + '","state_of_supply":"' + StateCust.Description +
        '","actual_to_state_name":"' + StateCust.Description + '","transaction_type":"' + Rec."Transaction Type" + '","other_value":"' + '' +
        '","total_invoice_value":"' + FORMAT(TotalInvAmt) + '","taxable_amount":"' + FORMAT(TotaltaxableAmt1Total) + '","cgst_amount":"' +
        '0' + '","sgst_amount":"' + '0' + '","igst_amount":"' + FORMAT(TotalIGSTAmt) + '","cess_amount":"' +
        '0' + '","cess_nonadvol_value":"' + '0' + '","transporter_id":"' + Location_."GST Registration No." + '","transporter_name":"' +
        /*EWayBillDetail."Transporter Name"*/ /*Rec."Transport Vendor"*/'' + '","transporter_document_number":"' + '' + '","transporter_document_date":"' + '' + '","transportation_mode":"' +
        /*EWayBillDetail."Transportation Mode"*/ Rec."Mode of Transport" + '","transportation_distance":"' + /*FORMAT(EWayBillDetail."Transport Distance")*/ '' + '","vehicle_number":"' +
        Rec."Vehicle No." + '","vehicle_type":"' + 'Regular' + '","generate_status":"' + '1' + '","data_source":"' + 'erp' + '","user_ref":"' + '' +
        '","location_code":"' + Location_.Code + '","eway_bill_status":"' + FORMAT(Rec."E-Way Bill Generate") + '","auto_print":"' + 'Y' + '","email":"' +
        Location_."E-Mail" + '"}';
        /*
Document_Date := FORMAT("Posting Date", 0, '<Day,2>/<Month,2>/<year4>');
Headerdata := '{"access_token":"' + token + '","userGstin":"' + '05AAABB0639G1Z8' + '","supply_type":"' + Supply + '","sub_supply_type":"' + Subsupply +
'","sub_supply_description":"' + SubSupplydescr + '","document_type":"' + DocumentType + '","document_number":"' + "No." +
'","document_date":"' + Document_Date + '","gstin_of_consignor":"' + '05AAABB0639G1Z8' + '","legal_name_of_consignor":"' + Location_.Name +
'","address1_of_consignor":"' + Location_.Address + '","address2_of_consignor":"' + Location_."Address 2" + '","place_of_consignor":"' +
Location_.City + '","pincode_of_consignor":"' + Location_."Post Code" + '","state_of_consignor":"' + State_.Description +
'","actual_from_state_name":"' + State_.Description + '","gstin_of_consignee":"' + '05AAABC0181E1ZE' + '","legal_name_of_consignee":"' + recToLoc.Name +
'","address1_of_consignee":"' + recToLoc.Address + '","address2_of_consignee":"' + recToLoc."Address 2" +
'","place_of_consignee":"' + recToLoc.City + '","pincode_of_consignee":"' + recToLoc."Post Code" + '","state_of_supply":"' + StateCust.Description +
'","actual_to_state_name":"' + StateCust.Description + '","transaction_type":"' + "Transaction Type" + '","other_value":"' + '' +
'","total_invoice_value":"' + FORMAT(TotalInvAmt) + '","taxable_amount":"' + FORMAT(TotaltaxableAmt1Total) + '","cgst_amount":"' +
'0' + '","sgst_amount":"' + '0' + '","igst_amount":"' + FORMAT(TotalIGSTAmt) + '","cess_amount":"' +
'0' + '","cess_nonadvol_value":"' + '0' + '","transporter_id":"' + '05AAABB0639G1Z8' + '","transporter_name":"' +
"Transport Vendor" + '","transporter_document_number":"' + '' + '","transporter_document_date":"' + '' + '","transportation_mode":"' +
"Mode of Transport" + '","transportation_distance":"' + FORMAT("Distance (Km)") + '","vehicle_number":"' +
"Vehicle No." + '","vehicle_type":"' + 'Regular' + '","generate_status":"' + '1' + '","data_source":"' + 'erp' + '","user_ref":"' + '' +
'","location_code":"' + Location_.Code + '","eway_bill_status":"' + FORMAT("E-Way Bill Generate") + '","auto_print":"' + 'Y' + '","email":"' +
Location_."E-Mail" + '"}';
*/
        //MESSAGE(Headerdata);
        //MESSAGE(Linedata);
        // result := Ewaybill.GenerateEwaybill(GeneralLedgerSetup."EINV Base URL", token, Headerdata, Linedata);
        //result := Ewaybill.GenerateEwaybill(GeneralLedgerSetup."EINV Base URL", token, Headerdata, Linedata, GeneralLedgerSetup."EINV Path");

        IF result <> 'Invalid Json' THEN BEGIN
            resresult := CONVERTSTR(result, ';', ',');
            resresult1 := SELECTSTR(1, resresult);
            resresult2 := SELECTSTR(2, resresult);
        END;

        IF (12 = STRLEN(resresult1)) THEN BEGIN
            IF EWayBillDetail.GET(Rec."No.") THEN BEGIN
                //EwaybillDetail.INIT;
                EWayBillDetail."Eway Bill No." := resresult1;
                EWayBillDetail."URL for PDF" := resresult2;
                EWayBillDetail."Ewaybill Error" := '';
                EWayBillDetail."Transportation Mode" := Rec."Mode of Transport";
                EWayBillDetail."Transport Distance" := Rec."Distance (Km)";
                //  EWayBillDetail."Transporter Name" := Rec."Transport Vendor";
                EWayBillDetail.MODIFY;
                //EWayBillDetail.Insert();
                TraShipHeader.Reset();
                TraShipHeader.SetRange("No.", Rec."No.");
                IF TraShipHeader.FindFirst() then begin
                    TraShipHeader."E-Way Bill Generate" := TraShipHeader."E-Way Bill Generate"::Generated;
                    TraShipHeader.MODIFY;
                end;
                MESSAGE(resresult1);
            END;
        END ELSE BEGIN
            EWayBillDetail."Ewaybill Error" := result;
            EWayBillDetail.MODIFY;
            COMMIT;
            ERROR(result);
        END;
        //PCPL41-EWAY

        /*
        IF 12 = STRLEN(result) THEN BEGIN
            "E-Way Bill Generate" := "E-Way Bill Generate"::Generated;
            "Eway Bill No." := result;
            MODIFY;
            MESSAGE(result);
        END ELSE BEGIN
            ERROR(result);
        END;
        //PCPL41-EWAY
        */

    end;

    local procedure GetTcsAmtLineWise(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'TCS');
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        //        TCSAMTLinewise := ComponentAmt;
        //until TaxTransactionValue.Next() = 0;
        exit(ComponentAmt)

    end;

    local procedure GetGSTBaseAmtLineWise(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'GST');
        TaxTransactionValue.SetRange("Value ID", 10);
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        exit(ComponentAmt)

    end;


}



