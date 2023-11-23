page 50604 "Posted Sales Invoice Eway"
{
    Caption = 'Posted Sales Invoice EWAY';
    InsertAllowed = false;
    ModifyAllowed = true;
    DeleteAllowed = false;
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Invoice,Correct,Print/Send,Navigate';
    RefreshOnActivate = true;
    SourceTable = "Sales Invoice Header";
    Permissions = tabledata 112 = rm;
    Editable = true;


    AboutTitle = 'About posted sales invoice details';
    AboutText = 'This sales invoice is posted and counting in the books. You can''t edit it directly, but you can post corrections if you have to make adjustments.';

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Editable = false;
                    Importance = Promoted;
                    TableRelation = Customer.Name;
                    ToolTip = 'Specifies the name of the customer that you shipped the items on the invoice to.';
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address"; Rec."Sell-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that the items on the invoice were shipped to.';
                    }
                    field("Sell-to Address 2"; Rec."Sell-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Sell-to City"; Rec."Sell-to City")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city of the customer on the sales document.';
                    }
                    group(Control88)
                    {
                        ShowCaption = false;
                        Visible = IsSellToCountyVisible;
                        field("Sell-to County"; Rec."Sell-to County")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'County';
                            Editable = false;
                            Importance = Additional;
                            ToolTip = 'Specifies the state, province or county as a part of the address.';
                        }
                    }
                    field("Sell-to Post Code"; Rec."Sell-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Sell-to Country/Region Code"; Rec."Sell-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Country/Region';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the country or region of the address.';
                    }
                    field("Sell-to Contact No."; Rec."Sell-to Contact No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies a unique identifier for the contact person at the customer the invoice was sent to.';
                    }
                    field(SellToPhoneNo; SellToContact."Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Phone No.';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the telephone number of the contact person at the customer the invoice was sent to.';
                    }
                    field(SellToMobilePhoneNo; SellToContact."Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mobile Phone No.';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the mobile telephone number of the contact person at the customer the invoice was sent to.';
                    }
                    field(SellToEmail; SellToContact."E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Email';
                        Importance = Additional;
                        Editable = false;
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the email address of the contact person at the customer the invoice was sent to.';
                    }
                }
                field("Sell-to Contact"; Rec."Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the customer the invoice was sent to.';
                }
                field("Your Reference"; Rec."Your Reference")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pay Reference';
                    Importance = Additional;
                    ToolTip = 'Specifies the customer''s reference. The contents will be printed on sales documents.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which you created the sales document.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the invoice was posted.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date on which the invoice is due for payment.';
                }
                field("GRN Posting No"; Rec."GRN Posting No")
                {
                    ApplicationArea = all;
                }
                field("GRN Posting Date"; Rec."GRN Posting Date")
                {
                    ApplicationArea = all;
                }
                field("Discrepancy Note No."; Rec."Discrepancy Note No.")
                {
                    ApplicationArea = all;
                }
                field("Discrepancy Note Date "; Rec."Discrepancy Note Date ")
                {
                    ApplicationArea = all;
                }

                group(Control3)
                {
                    ShowCaption = false;
                    Visible = DocExcStatusVisible;
                    field("Document Exchange Status"; Rec."Document Exchange Status")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        Importance = Additional;
                        StyleExpr = DocExchStatusStyle;
                        ToolTip = 'Specifies the status of the document if you are using a document exchange service to send it as an electronic document. The status values are reported by the document exchange service.';

                        trigger OnDrillDown()
                        var
                            DocExchServDocStatus: Codeunit "Doc. Exch. Serv.- Doc. Status";
                        begin
                            DocExchServDocStatus.DocExchStatusDrillDown(Rec);
                        end;
                    }
                }
                field("Quote No."; Rec."Quote No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the number of the sales quote document if a quote was used to start the sales process.';
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the sales order that this invoice was posted from.';
                }
                field("Pre-Assigned No."; Rec."Pre-Assigned No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the sales document that the posted invoice was created for.';
                }
                field("External Document No."; Rec."External Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the external document number that is entered on the sales header that this line was posted from.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies which salesperson is associated with the invoice.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    AccessByPermission = TableData "Responsibility Center" = R;
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the responsibility center associated with the user who created the invoice, your company, or the customer in the sales invoice.';
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how many times the document has been printed.';
                }


                group("Work Description")
                {
                    Caption = 'Work Description';
                    field(GetWorkDescription; Rec.GetWorkDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = false;
                        Importance = Additional;
                        MultiLine = true;
                        ShowCaption = false;
                    }
                }
            }
            part(SalesInvLines; "Posted Sales Invoice Sub Eway")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Document No." = FIELD("No.");
            }
            group("Einvoice Details")
            {
                part("E-Invoice Detail"; "E-Invoice Detail")
                {
                    SubPageLink = "Document No." = FIELD("No.");
                    ApplicationArea = all;
                }
            }
            group("E-way Bill Data")
            {
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                    ApplicationArea = all;
                    Caption = 'Agent';
                    Editable = True;
                    Importance = Additional;
                    ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';

                    trigger OnValidate()
                    begin
                        IF ShipAgent.GET(Rec."Shipping Agent Code") then begin
                            Rec."Transport Vendor Name" := Shipagent.Name;
                        end

                    end;
                }

                field("Transport Vendor Name"; Rec."Transport Vendor Name")
                {
                    ApplicationArea = all;
                }
                Field("Transport Method"; Rec."Transport Method")
                {
                    ApplicationArea = all;
                }
                field("E-Way Bill Generate"; Rec."E-Way Bill Generate")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                // Field("E-Way Bill Date"; Rec."E-Way Bill Date")
                // {
                //     ApplicationArea = all;
                // }
                // field("E-Way Bill DateTime"; Rec."E-Way Bill DateTime")
                // {
                //     ApplicationArea = all;
                // }
                // field("PAY REF DATE"; Rec."PAY REF DATE")
                // {
                //     ApplicationArea = all;
                // }
                Field("Vehicle No."; Rec."Vehicle No.")
                {
                    ApplicationArea = all;
                }
                field("Distance (Km)"; Rec."Distance (Km)")
                {
                    ApplicationArea = all;
                }
                Field("LR/RR Date"; Rec."LR/RR Date")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
                field("LR/RR No."; Rec."LR/RR No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                }


            }

            group("E-Way Bill Details")
            {
                part("E-Way Bill Detail"; "E-Way Bill Detail")
                {
                    ApplicationArea = all;
                    SubPageLink = "Document No." = field("No.");

                }
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details';
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code of the invoice.';

                    trigger OnAssistEdit()
                    var
                        UpdateCurrencyFactor: Codeunit "Update Currency Factor";
                    begin
                        ChangeExchangeRate.SetParameter(Rec."Currency Code", Rec."Currency Factor", Rec."Posting Date");
                        ChangeExchangeRate.Editable(false);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Rec."Currency Factor" := ChangeExchangeRate.GetParameter;
                            UpdateCurrencyFactor.ModifyPostedSalesInvoice(Rec);
                        end;
                        Clear(ChangeExchangeRate);
                    end;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies when items on the document are shipped or were shipped. A shipment date is usually calculated from a requested delivery date plus lead time.';
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies a formula that calculates the payment due date, payment discount date, and payment discount amount on the sales document.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies how the customer must pay for products on the sales document.';
                }
                group(Control15)
                {
                    ShowCaption = false;
                    Visible = PaymentServiceVisible;
                    field(SelectedPayments; Rec.GetSelectedPaymentsText)
                    {
                        ApplicationArea = All;
                        Caption = 'Payment Service';
                        Editable = false;
                        Enabled = PaymentServiceEnabled;
                        MultiLine = true;
                        ToolTip = 'Specifies the payment service, such as PayPal, that the sales invoice can be paid with.';

                        trigger OnAssistEdit()
                        var
                            PaymentServiceSetup: Record "Payment Service Setup";
                        begin
                            PaymentServiceSetup.ChangePaymentServicePostedInvoice(Rec);
                            CurrPage.Update(false);
                        end;
                    }
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2, which is one of two global dimension codes that you set up in the General Ledger Setup window.';
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    ToolTip = 'Specifies the payment discount percent granted if payment is made on or before the date in the Pmt. Discount Date field.';
                }
                field("Pmt. Discount Date"; Rec."Pmt. Discount Date")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the date on which the amount in the entry must be paid for a payment discount to be granted.';
                }

                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for the location from which the items were shipped.';
                }
            }
            group("Shipping and Billing")
            {
                Caption = 'Shipping and Billing';
                group("Shipping Details")
                {
                    Caption = 'Shipping Details';
                    field("Shipment Method Code"; Rec."Shipment Method Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Method';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the code that represents the shipment method for the invoice.';
                    }

                    field("Package Tracking No."; Rec."Package Tracking No.")
                    {
                        ApplicationArea = Suite;
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the shipping agent''s package number.';
                    }
                }
                group("Ship-to")
                {
                    Caption = 'Ship-to';
                    field("Ship-to Code"; Rec."Ship-to Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address Code';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the address on purchase orders shipped with a drop shipment directly from the vendor to a customer.';
                    }
                    field("Ship-to Name"; Rec."Ship-to Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Name';
                        Editable = false;
                        ToolTip = 'Specifies the name of the customer that the items were shipped to.';
                    }
                    field("Ship-to Address"; Rec."Ship-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address';
                        Editable = false;
                        ToolTip = 'Specifies the address that the items on the invoice were shipped to.';
                    }
                    field("Ship-to Address 2"; Rec."Ship-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Ship-to City"; Rec."Ship-to City")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'City';
                        Editable = false;
                        ToolTip = 'Specifies the city of the customer on the sales document.';
                    }
                    group(Control93)
                    {
                        ShowCaption = false;
                        Visible = IsShipToCountyVisible;
                    }
                    field("Ship-to County"; Rec."Ship-to County")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'County';
                        Editable = false;
                        ToolTip = 'Specifies the state, province or county as a part of the address.';
                    }
                    field("Ship-to Post Code"; Rec."Ship-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Code';
                        Editable = false;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Country/Region';
                        Editable = false;
                        ToolTip = 'Specifies the country or region of the address.';
                    }
                    field("Ship-to Contact"; Rec."Ship-to Contact")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the person you regularly contact at the address that the items were shipped to.';
                    }
                }
                group("Bill-to")
                {
                    Caption = 'Bill-to';
                    field("Bill-to Name"; Rec."Bill-to Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Name';
                        Editable = false;
                        Importance = Promoted;
                        ToolTip = 'Specifies the name of the customer that the invoice was sent to.';
                    }
                    field("Bill-to Address"; Rec."Bill-to Address")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the address of the customer that the invoice was sent to.';
                    }
                    field("Bill-to Address 2"; Rec."Bill-to Address 2")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies additional address information.';
                    }
                    field("Bill-to City"; Rec."Bill-to City")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city of the customer on the sales document.';
                    }
                    group(Control95)
                    {
                        ShowCaption = false;
                        Visible = IsBillToCountyVisible;
                        field("Bill-to County"; Rec."Bill-to County")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'County';
                            Editable = false;
                            Importance = Additional;
                            ToolTip = 'Specifies the state, province or county as a part of the address.';
                        }
                    }
                    field("Bill-to Post Code"; Rec."Bill-to Post Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Post Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the postal code.';
                    }
                    field("Bill-to Country/Region Code"; Rec."Bill-to Country/Region Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Country/Region';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the country or region of the address.';
                    }
                    field("Bill-to Contact No."; Rec."Bill-to Contact No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the number of the contact the invoice was sent to.';
                    }
                    field("Bill-to Contact"; Rec."Bill-to Contact")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Contact';
                        Editable = false;
                        ToolTip = 'Specifies the name of the person you regularly contact when you communicate with the customer to whom the invoice was sent.';
                    }
                    field(BillToContactPhoneNo; BillToContact."Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Phone No.';
                        Editable = false;
                        Importance = Additional;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the telephone number of the person you regularly contact when you communicate with the customer to whom the invoice was sent.';
                    }
                    field(BillToContactMobilePhoneNo; BillToContact."Mobile Phone No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Mobile Phone No.';
                        Editable = false;
                        Importance = Additional;
                        ExtendedDatatype = PhoneNo;
                        ToolTip = 'Specifies the mobile telephone number of the person you regularly contact when you communicate with the customer to whom the invoice was sent.';
                    }
                    field(BillToContactEmail; BillToContact."E-Mail")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Email';
                        Editable = false;
                        Importance = Additional;
                        ExtendedDatatype = EMail;
                        ToolTip = 'Specifies the email address of the person you regularly contact when you communicate with the customer to whom the invoice was sent.';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("EU 3-Party Trade"; Rec."EU 3-Party Trade")
                {
                    ApplicationArea = BasicEU;
                    Editable = false;
                    ToolTip = 'Specifies whether the invoice was part of an EU 3-party trade transaction.';
                }
                field("Transaction Specification"; Rec."Transaction Specification")
                {
                    ApplicationArea = BasicEU;
                    Editable = false;
                    ToolTip = 'Specifies the transaction specification that was used in the invoice.';
                }

                field("Exit Point"; Rec."Exit Point")
                {
                    ApplicationArea = BasicEU;
                    Editable = false;
                    ToolTip = 'Specifies the point of exit through which you ship the items out of your country/region, for reporting to Intrastat.';
                }
                field("Area"; Rec.Area)
                {
                    ApplicationArea = BasicEU;
                    Editable = false;
                    ToolTip = 'Specifies the area code used in the invoice.';
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(112),
                              "No." = FIELD("No.");
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                Visible = NOT IsOfficeAddin;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice';
                Image = Invoice;
                action(Statistics)
                {
                    ApplicationArea = Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Invoice Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                    ToolTip = 'View or add comments for the record.';
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions();
                    end;
                }
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
                    // SalesPost: Codeunit 80;
                    begin
                        //PCPL41-EWAY
                        IF NOT CONFIRM('Do you want generate E-Way Bill?') THEN
                            EXIT;
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetRange(SalesInvHeader."No.", Rec."No.");
                        IF SalesInvHeader.FindFirst() then begin
                            Rec."E-Way Bill Generate" := Rec."E-Way Bill Generate"::"To Generate";
                            Rec.Modify();
                        end;

                        IF Rec."E-Way Bill Generate" = Rec."E-Way Bill Generate"::"To Generate" THEN
                            CheckEwaybill_returnV
                        ELSE
                            ERROR('E-way Bill Generate should be "To Generate".');
                        //PCPL41-EWAY
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Posted Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ShowPostedApprovalEntries(Rec.RecordId);
                    end;
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
                separator(Action171)
                {
                }
                action(ChangePaymentService)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Change Payment Service';
                    Image = ElectronicPayment;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Change or add the payment service, such as PayPal Standard, that will be included on the sales document so the customer can quickly access the payment site.';
                    Visible = PaymentServiceVisible;

                    trigger OnAction()
                    var
                        PaymentServiceSetup: Record "Payment Service Setup";
                    begin
                        PaymentServiceSetup.ChangePaymentServicePostedInvoice(Rec);
                    end;
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics 365 Sales';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoInvoice)
                {
                    ApplicationArea = Suite;
                    Caption = 'Invoice';
                    Enabled = CRMIsCoupledToRecord;
                    Image = CoupledSalesInvoice;
                    ToolTip = 'Open the coupled Dynamics 365 Sales invoice.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(Rec.RecordId);
                    end;
                }
                action(CreateInCRM)
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Invoice in Dynamics 365 Sales';
                    Enabled = NOT CRMIsCoupledToRecord;
                    Image = NewSalesInvoice;
                    ToolTip = 'Create a sales invoice in Dynamics 365 Sales that is connected to this posted sales invoice.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.CreateNewRecordsInCRM(Rec.RecordId);
                    end;
                }
                action(ShowLog)
                {
                    ApplicationArea = Suite;
                    Caption = 'Synchronization Log';
                    Image = Log;
                    ToolTip = 'View integration synchronization jobs for the posted sales invoice table.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowLog(Rec.RecordId);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Track Package")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Track Package';
                    Image = ItemTracking;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Open the shipping agent''s tracking page to track the package. ';

                    trigger OnAction()
                    begin
                        Rec.StartTrackingSite();
                    end;
                }
            }
            action(SendCustom)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send';
                Ellipsis = true;
                Image = SendToMultiple;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                ToolTip = 'Prepare to send the document according to the customer''s sending profile, such as attached to an email. The Send document to window opens first so you can confirm or select a sending profile.';

                trigger OnAction()
                var
                    SalesInvHeader: Record "Sales Invoice Header";
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.SendRecords;
                end;
            }
            action(Print)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category6;
                ToolTip = 'Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    IsHandled: Boolean;
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    IsHandled := false;
                    OnBeforeSalesInvHeaderPrintRecords(SalesInvHeader, IsHandled);
                    if not IsHandled then
                        SalesInvHeader.PrintRecords(true);
                end;
            }
            action(Email)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Email';
                Image = Email;
                Promoted = true;
                PromotedCategory = Category6;
                ToolTip = 'Prepare to email the document. The Send Email window opens prefilled with the customer''s email address so you can add or edit information.';

                trigger OnAction()
                begin
                    SalesInvHeader := Rec;
                    CurrPage.SetSelectionFilter(SalesInvHeader);
                    SalesInvHeader.EmailRecords(true);
                end;
            }
            action(AttachAsPDF)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attach as PDF';
                Image = PrintAttachment;
                Promoted = true;
                PromotedCategory = Category6;
                ToolTip = 'Create a PDF file and attach it to the document.';

                trigger OnAction()
                var
                    SalesInvoiceHeader: Record "Sales Invoice Header";
                begin
                    SalesInvoiceHeader := Rec;
                    SalesInvoiceHeader.SetRecFilter();
                    Rec.PrintToDocumentAttachment(SalesInvoiceHeader);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Find entries...';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                ShortCutKey = 'Shift+Ctrl+I';
                AboutTitle = 'Get detailed posting details';
                AboutText = 'Here, you can look up the ledger entries that were created when this invoice was posted, as well as any related documents.';
                ToolTip = 'Find entries and documents that exist for the document number and posting date on the selected document. (Formerly this action was named Navigate.)';
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;
                ToolTip = 'View the status and any errors if the document was sent as an electronic document or OCR file through the document exchange service.';

                trigger OnAction()
                begin
                    Rec.ShowActivityLog;
                end;
            }
            action("Update Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Document';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Add new information that is relevant to the document, such as a payment reference. You can only edit a few fields because the document has already been posted.';

                trigger OnAction()
                var
                    PostedSalesInvUpdate: Page "Posted Sales Inv. - Update";
                begin
                    PostedSalesInvUpdate.LookupMode := true;
                    PostedSalesInvUpdate.SetRec(Rec);
                    PostedSalesInvUpdate.RunModal();
                end;
            }
            group(IncomingDocument)
            {
                Caption = 'Incoming Document';
                Image = Documents;
                action(IncomingDocCard)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'View Incoming Document';
                    Enabled = HasIncomingDocument;
                    Image = ViewOrder;
                    ToolTip = 'View any incoming document records and file attachments that exist for the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard(Rec."No.", Rec."Posting Date");
                    end;
                }
                action(SelectIncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Select Incoming Document';
                    Enabled = NOT HasIncomingDocument;
                    Image = SelectLineToApply;
                    ToolTip = 'Select an incoming document record and file attachment that you want to link to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.SelectIncomingDocumentForPostedDocument(Rec."No.", Rec."Posting Date", Rec.RecordId);
                    end;
                }
                action(IncomingDocAttachFile)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Incoming Document from File';
                    Ellipsis = true;
                    Enabled = NOT HasIncomingDocument;
                    Image = Attach;
                    ToolTip = 'Create an incoming document record by selecting a file to attach, and then link the incoming document record to the entry or document.';

                    trigger OnAction()
                    var
                        IncomingDocumentAttachment: Record "Incoming Document Attachment";
                    begin
                        IncomingDocumentAttachment.NewAttachmentFromPostedDocument(Rec."No.", Rec."Posting Date");
                    end;
                }
            }
            group(Correct)
            {
                Caption = 'Correct';


                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Corrective Credit Memo';
                    Image = CreateCreditMemo;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedOnly = true;
                    ToolTip = 'Create a credit memo for this posted invoice that you complete and post manually to reverse the posted invoice.';

                    trigger OnAction()
                    var
                        SalesHeader: Record "Sales Header";
                        CorrectPostedSalesInvoice: Codeunit "Correct Posted Sales Invoice";
                    begin
                        if CorrectPostedSalesInvoice.CreateCreditMemoCopyDocument(Rec, SalesHeader) then begin
                            PAGE.Run(PAGE::"Sales Credit Memo", SalesHeader);
                            CurrPage.Close;
                        end;
                    end;
                }

            }
            group(Invoice)
            {
                Caption = 'Invoice';
                Image = Invoice;
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                    ToolTip = 'View or edit detailed information about the customer.';
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        IncomingDocument: Record "Incoming Document";
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        if GuiAllowed() then begin
            HasIncomingDocument := IncomingDocument.PostedDocExists(Rec."No.", Rec."Posting Date");
            DocExchStatusStyle := Rec.GetDocExchStatusStyle;
            CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
            if CRMIntegrationEnabled then begin
                CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
                if Rec."No." <> xRec."No." then
                    CRMIntegrationManagement.SendResultNotification(Rec);
            end;
        end;
        UpdatePaymentService;
        DocExcStatusVisible := Rec.DocExchangeStatusIsSent;
    end;

    trigger OnAfterGetRecord()
    begin
        DocExchStatusStyle := Rec.GetDocExchStatusStyle;
        SellToContact.GetOrClear(Rec."Sell-to Contact No.");
        BillToContact.GetOrClear(Rec."Bill-to Contact No.");

        //PCPL0017-EWAY
        EWayBillDetailNew.RESET;
        EWayBillDetailNew.SETRANGE("Document No.", Rec."No.");
        EWayBillDetailNew.SETFILTER("Eway Bill No.", '<>%1', '');
        IF EWayBillDetailNew.FINDFIRST THEN BEGIN
            EWAYGEN := FALSE;
        END ELSE
            EWAYGEN := TRUE;
        //PCPL0017-EWAY

    end;

    trigger OnInit()
    begin
        DocExcStatusVisible := true;
    end;

    trigger OnOpenPage()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
        OfficeMgt: Codeunit "Office Management";
    begin
        Rec.SetSecurityFilterOnRespCenter;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

        IsOfficeAddin := OfficeMgt.IsAvailable;

        ActivateFields;
        PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;

        //PCPL0017-EWAY
        EWayBillDetailNew.RESET;
        EWayBillDetailNew.SETRANGE("Document No.", Rec."No.");
        EWayBillDetailNew.SETFILTER("Eway Bill No.", '<>%1', '');
        IF EWayBillDetailNew.FINDFIRST THEN BEGIN
            EWAYGEN := FALSE;
        END ELSE
            EWAYGEN := TRUE;
        //PCPL0017-EWAY

    end;

    var
        ShipAgent: record 291;
        SalesInvHeader: Record "Sales Invoice Header";
        EWAYGEN: boolean;
        EWayBillDetailNew: record 50602;

        SellToContact: Record Contact;
        BillToContact: Record Contact;
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        HasIncomingDocument: Boolean;
        DocExchStatusStyle: Text;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        PaymentServiceVisible: Boolean;
        PaymentServiceEnabled: Boolean;
        DocExcStatusVisible: Boolean;
        IsOfficeAddin: Boolean;
        IsBillToCountyVisible: Boolean;
        IsSellToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;



    local procedure ActivateFields()
    begin
        IsBillToCountyVisible := FormatAddress.UseCounty(Rec."Bill-to Country/Region Code");
        IsSellToCountyVisible := FormatAddress.UseCounty(Rec."Sell-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty(Rec."Ship-to Country/Region Code");
    end;

    local procedure UpdatePaymentService()
    var
        PaymentServiceSetup: Record "Payment Service Setup";
    begin
        PaymentServiceEnabled := PaymentServiceSetup.CanChangePaymentService(Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesInvHeaderPrintRecords(var SalesInvHeader: Record "Sales Invoice Header"; var IsHandled: Boolean)
    begin
    end;

    procedure CheckEwaybill_returnV();
    var
        Headerdata: Text;
        Linedata: Text;
        Cust: Record 18;
        PostedSalesLine: Record 113;
        Location_: Record 14;
        State_: Record State;
        StateCust: Record State;
        ShiptoCode: Record 222;
        ComInfo: Record 79;
        HSNSAN: Record "HSN/SAC";
        ShipQty: Decimal;
        cnt: Integer;
        Item_: Record 27;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CESSGSTAmt: Decimal;
        CgstRate: Decimal;
        SgstRate: Decimal;
        IgstRate: Decimal;
        CESSgstRate: Decimal;
        TotalCGSTAmt: Decimal;
        TotalSGSTAmt: Decimal;
        TotalIGSTAmt: Decimal;
        TotalCESSGSTAmt: Decimal;
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
        EWayBillDetail1: Record 50602;
        GeneralLedgerSetup: Record 98;
        SalesInvLine: Record 113;
        TotaltaxableAmt1: Text;
        //Ewaybill: DotNet Ewaybillcontroller;
        token: Text;
        result: Text;
        resresult: Text;
        resresult1: Text;
        resresult2: Text;
        Transport_Date: Text;
        consignee_gstin: Text;
        consignee_name: Text;
        consignee_address1: Text;
        consignee_address2: Text;
        consignee_place: Text;
        consignee_pincode: Text;
        consignee_StateofSupply: Text;
        consignee_StateName: Text;
        Ship_to_state: Record State;
        Recustomer: Record 18;
        RecshiptoAddress: Record 222;
        TotaltaxableAmtValue: Decimal;
        TotaltaxableAmtValue1: Text;
        SIH: Record 112;
        AmountToCustomer: Decimal;
        TotalGSTAmount: Decimal;
        //<<PCPL/NSW/EINV 052522
        SalesInvLineNewEway: Record 113;
        TaxRecordIDEWAY: RecordId;
        TCSAMTLinewiseEWAY: Decimal;
        GSTBaseAmtLineWiseEWAY: Decimal;
        ComponentJobjectEWAY: JsonObject;
        EWayBillDetail: Record 50602;
        SalesInvHeader: Record 112;
        Desc: Text[100];
        ChargeItem: record 5800;
        JsonEinvObject: JsonObject;
        EinvRequestTxt: Text;
        EinvRequestContent: HttpContent;
        EinvResponse: HttpResponseMessage;
        Einvcontent: HttpContent;
        EinvResponseTxt: Text;
        ReqOStm: OutStream;
        ReqInStm: InStream;
        ReqtempBlob: Codeunit "Temp Blob";
        FileName: text;
        HttpHead: HttpHeaders;
        client: HttpClient;
        Response: HttpResponseMessage;
        EwayJarray: JsonArray;
        LineObj: JsonObject;
        RecItem: Record 27;
    //>>PCPL/NSW/EINV 052522
    //Nirmal
    begin
        //PCPL41-EWAY
        GeneralLedgerSetup.GET;
        IF Cust.GET(Rec."Sell-to Customer No.") THEN;
        IF Location_.GET(Rec."Location Code") THEN;
        IF State_.GET(Location_."State Code") THEN;
        IF ShiptoCode.GET(Rec."Sell-to Customer No.", Rec."Ship-to Code") THEN;
        IF Ship_to_state.GET(ShiptoCode.State) THEN;
        IF StateCust.GET(Cust."State Code") THEN;
        //PCPL0017
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_gstin := ShiptoCode."GST Registration No.";
        END ELSE
            consignee_gstin := Cust."GST Registration No.";
        if Cust."GST Customer Type" = Cust."GST Customer Type"::Unregistered then
            consignee_gstin := 'URP';
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_address1 := ShiptoCode.Address;
        END ELSE
            consignee_address1 := Cust.Address;
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_address2 := ShiptoCode."Address 2";
        END ELSE
            consignee_address2 := Cust."Address 2";
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_name := ShiptoCode.Name;
        END ELSE
            consignee_name := Cust.Name;
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_pincode := ShiptoCode."Post Code";
        END ELSE
            consignee_pincode := Cust."Post Code";
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_place := ShiptoCode.City;
        END ELSE
            consignee_place := Cust.City;
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_StateofSupply := Ship_to_state.Description;
        END ELSE
            consignee_StateofSupply := StateCust.Description;
        IF Rec."Ship-to Code" <> '' THEN BEGIN
            consignee_StateName := Ship_to_state.Description;
        END ELSE
            consignee_StateName := StateCust.Description;

        IF SIH.get(Rec."No.") then;
        GetStatisticsPostedSalesInvAmount(SIH, TotalGSTAmount, AmountToCustomer);
        //CALCFIELDS("Amount to Customer");



        ShipQty := 0;
        LineTaxableAmt := 0;
        LineInvoiceAmt := 0;
        TotalIGSTAmt := 0;
        TotalCGSTAmt := 0;
        TotalTaxableAmt := 0;
        TotaltaxableAmtValue := 0;
        CLEAR(TotaltaxableAmtValue1);
        //<<PCPL/NSW/EINV 052522
        Clear(GSTBaseAmtLineWiseEWAY);
        Clear(TCSAMTLinewiseEWAY);
        Clear(TaxRecordIDEWAY);
        Clear(EwayJarray);
        //<<PCPL/NSW/EINV 052522

        cnt := 0;
        Linedata := '[';
        SalesInvLine.RESET;
        SalesInvLine.SETCURRENTKEY("Document No.", "Line No.");
        SalesInvLine.SETRANGE("Document No.", Rec."No.");
        SalesInvLine.SETFILTER(Type, '<>%1', SalesInvLine.Type::" ");
        SalesInvLine.SETFILTER(Quantity, '<>%1', 0);
        IF SalesInvLine.FINDSET THEN
            REPEAT
                CGSTAmt := 0;
                SGSTAmt := 0;
                IGSTAmt := 0;
                CgstRate := 0;
                SgstRate := 0;
                IgstRate := 0;
                CESSGSTAmt := 0;
                CESSgstRate := 0;
                Clear(Desc);
                //>>PCPL/NSW/EINV 052522
                Clear(GSTBaseAmtLineWiseEWAY);
                Clear(TCSAMTLinewiseEWAY);
                Clear(TaxRecordIDEWAY);
                //<<PCPL/NSW/EINV 052522
                DetailedGSTLedgerEntry.RESET;
                DetailedGSTLedgerEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                DetailedGSTLedgerEntry.SETRANGE("Document No.", SalesInvLine."Document No.");
                DetailedGSTLedgerEntry.SETRANGE("Document Line No.", SalesInvLine."Line No.");
                IF DetailedGSTLedgerEntry.FINDSET THEN
                    REPEAT
                        IF DetailedGSTLedgerEntry."GST Component Code" = 'CGST' THEN BEGIN
                            CGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                            CgstRate := DetailedGSTLedgerEntry."GST %";
                            Supply := 'Outward';
                            Subsupply := 'Supply';
                            SubSupplydescr := '';
                        END ELSE
                            IF DetailedGSTLedgerEntry."GST Component Code" = 'SGST' THEN BEGIN
                                SGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                SgstRate := DetailedGSTLedgerEntry."GST %";
                                Supply := 'Outward';
                                Subsupply := 'Supply';
                                SubSupplydescr := '';
                            END ELSE
                                IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN
                                    IGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                    IgstRate := DetailedGSTLedgerEntry."GST %";
                                    Supply := 'Outward';
                                    Subsupply := 'Supply';
                                END ELSE
                                    IF DetailedGSTLedgerEntry."GST Component Code" = 'CESS' THEN BEGIN
                                        CESSGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                        CESSgstRate := DetailedGSTLedgerEntry."GST %";
                                        Supply := 'Outward';
                                        Subsupply := 'Supply';
                                    END;
                    UNTIL DetailedGSTLedgerEntry.NEXT = 0;

                /*
                IF SalesInvLine."Unit of Measure Code" = 'PAIR' THEN
                  UomValue := 'PRS'
                ELSE
                  UomValue := 'PCS';
                */

                TotalCGSTAmt += CGSTAmt;
                TotalSGSTAmt += SGSTAmt;
                TotalIGSTAmt += IGSTAmt;
                TotalCESSGSTAmt += CESSGSTAmt;

                //<<PCPL/NSW/EINV 052522
                if SalesInvLineNewEway.Get(SalesInvLine."Document No.", SalesInvLine."Line No.") then
                    TaxRecordIDEWAY := SalesInvLine.RecordId();
                TCSAMTLinewiseEWAY := GetTcsAmtLineWise(TaxRecordIDEWAY, ComponentJobjectEWAY);
                GSTBaseAmtLineWiseEWAY := GetGSTBaseAmtLineWise(TaxRecordIDEWAY, ComponentJobjectEWAY);
                //>>PCPL/NSW/EINV 052522

                //IF (SalesInvLine."GST Base Amount" = 0) AND (SalesInvLine."No." <> GeneralLedgerSetup."Round of G/L Account") THEN BEGIN //PCPL/NSW/EINV 052522  Old Code Comment field not Exist in BC 19
                IF (GSTBaseAmtLineWiseEWAY = 0) AND (SalesInvLine."No." <> GeneralLedgerSetup."Round of G/L Account") THEN BEGIN //PCPL/NSW/EINV 052522  New Code added
                    TotalTaxableAmt := SalesInvLine.Amount; //NEW
                    DocumentType := 'Delivery Challan';
                    Supply := 'Outward';
                    Subsupply := 'Others';
                    SubSupplydescr := 'Others';
                END ELSE BEGIN
                    //TotalTaxableAmt += SalesInvLine."GST Base Amount"; //OLD
                    TotalTaxableAmt := GSTBaseAmtLineWiseEWAY;//SalesInvLine."GST Base Amount";  //PCPL/NSW/EINV 052522 New Code Added
                    DocumentType := 'Tax Invoice';
                    Supply := 'Outward';
                    Subsupply := 'Supply';
                END;

                LineTaxableAmt += GSTBaseAmtLineWiseEWAY;//SalesInvLine."GST Base Amount";  //PCPL/NSW/EINV 052522 New Code Added
                LineInvoiceAmt += 0;//SalesInvLine."Amount To Customer"; //PCPL/NSW/EINV 052522 pass 0 coz field not eist in BC 19 

                ShipQty := SalesInvLine.Quantity;

                IF Item_.GET(SalesInvLine."No.") THEN;

                IF TotalTaxableAmt > 0/*1000*/ THEN
                    TotaltaxableAmt1 := DELCHR(FORMAT(TotalTaxableAmt), '=', ',');

                TotaltaxableAmtValue += TotalTaxableAmt;
                IF TotaltaxableAmtValue > 0/*1000*/ THEN
                    TotaltaxableAmtValue1 := DELCHR(FORMAT(TotaltaxableAmtValue), '=', ',');

                IF Item_.Get(SalesInvLine."No.") then
                    IF Item_."Description 2" = '' then
                        Desc := SalesInvLine."Description 2"
                    else
                        Desc := Item_."Description 2"
                else
                    if ChargeItem.Get(SalesInvLine."No.") then
                        desc := ChargeItem.Description
                    else
                        desc := SalesInvLine.Description;



                IF ShipQty <> 0 THEN BEGIN
                    cnt += 1;
                    IF (cnt = 1) AND (SalesInvLine."No." <> GeneralLedgerSetup."Round of G/L Account") THEN
                        Linedata += '{"product_name":"' + desc /*Item_."Description 2"*/+ '","product_description":"' + SalesInvLine.Description/*Item_."Description 2"*/ + '","hsn_code":"' +
                        SalesInvLine."HSN/SAC Code" + '","quantity":"' + FORMAT(ShipQty) + '","unit_of_product":"' + SalesInvLine."Unit of Measure Code" + '","cgst_rate":"' + FORMAT(CgstRate) +
                        '","sgst_rate":"' + FORMAT(SgstRate) + '","igst_rate":"' + FORMAT(IgstRate) + '","cess_rate":"' + FORMAT(CESSgstRate) + '","cessNonAdvol":"' + '0' +
                        '","taxable_amount":"' + FORMAT(/*TotalTaxableAmt*/TotaltaxableAmt1) + '"}'
                    ELSE
                        IF SalesInvLine."No." <> GeneralLedgerSetup."Round of G/L Account" THEN
                            Linedata += ',{"product_name":"' + Desc/*SalesInvLine.Description Item_."Description 2"*/ + '","product_description":"' + SalesInvLine.Description /*Item_."Description 2"*/ + '","hsn_code":"' +
                            SalesInvLine."HSN/SAC Code" + '","quantity":"' + FORMAT(ShipQty) + '","unit_of_product":"' + SalesInvLine."Unit of Measure Code" + '","cgst_rate":"' + FORMAT(CgstRate) +
                            '","sgst_rate":"' + FORMAT(SgstRate) + '","igst_rate":"' + FORMAT(IgstRate) + '","cess_rate":"' + FORMAT(CESSgstRate) + '","cessNonAdvol":"' + '0' +
                              '","taxable_amount":"' + FORMAT(/*TotalTaxableAmt*/TotaltaxableAmt1) + '"}';
                END;
                IF SalesInvLine.Type = SalesInvLine.Type::Item then
                    IF RecItem.get(SalesInvLine."No.") then;
                IF ShipQty <> 0 THEN BEGIN
                    cnt += 1;
                    IF (cnt = 1) AND (SalesInvLine."No." <> GeneralLedgerSetup."Round of G/L Account") THEN begin
                        Clear(LineObj);
                        LineObj.Add('product_name', desc);
                        LineObj.Add('product_description', RecItem."Description 2");
                        LineObj.Add('hsn_code', SalesInvLine."HSN/SAC Code");
                        LineObj.Add('quantity', FORMAT(ShipQty));
                        LineObj.Add('unit_of_product', SalesInvLine."Unit of Measure Code");
                        LineObj.Add('cgst_rate', FORMAT(CgstRate));
                        LineObj.Add('sgst_rate', FORMAT(SgstRate));
                        LineObj.Add('igst_rate', FORMAT(IgstRate));
                        LineObj.Add('cess_rate', FORMAT(CESSgstRate));
                        LineObj.Add('cessNonAdvol', Format(0));
                        LineObj.Add('taxable_amount', FORMAT(TotaltaxableAmt1));
                        EwayJarray.Add(LineObj);
                    end ELSE
                        IF SalesInvLine."No." <> GeneralLedgerSetup."Round of G/L Account" THEN begin
                            Clear(LineObj);
                            LineObj.Add('product_name', desc);
                            LineObj.Add('product_description', RecItem."Description 2");
                            LineObj.Add('hsn_code', SalesInvLine."HSN/SAC Code");
                            LineObj.Add('quantity', FORMAT(ShipQty));
                            LineObj.Add('unit_of_product', SalesInvLine."Unit of Measure Code");
                            LineObj.Add('cgst_rate', FORMAT(CgstRate));
                            LineObj.Add('sgst_rate', FORMAT(SgstRate));
                            LineObj.Add('igst_rate', FORMAT(IgstRate));
                            LineObj.Add('cess_rate', FORMAT(CESSgstRate));
                            LineObj.Add('cessNonAdvol', Format(0));
                            LineObj.Add('taxable_amount', FORMAT(TotaltaxableAmt1));
                            EwayJarray.Add(LineObj);
                        end;

                END;
            UNTIL SalesInvLine.NEXT = 0;

        Linedata := Linedata + ']';


        /*
        Ewaybill := Ewaybill.eWaybillController;
        token := Ewaybill.GetToken(GeneralLedgerSetup."EINV Base URL", GeneralLedgerSetup."EINV User Name", GeneralLedgerSetup."EINV Password",
        GeneralLedgerSetup."EINV Client ID", GeneralLedgerSetup."EINV Client Secret", GeneralLedgerSetup."EINV Grant Type", GeneralLedgerSetup."EINV Path");
        */
        IF EWayBillDetail.GET(Rec."No.") then;
        /*
        Headerdata := '{"access_token":"' + token + '","userGstin":"' + Location_."GST Registration No." + '","supply_type":"' + Supply + '","sub_supply_type":"' + Subsupply +
        '","sub_supply_description":"' + SubSupplydescr + '","document_type":"' + DocumentType + '","document_number":"' + Rec."No." +
        '","document_date":"' + Document_Date + '","gstin_of_consignor":"' + Location_."GST Registration No." + '","legal_name_of_consignor":"' + Location_.Name +
        '","address1_of_consignor":"' + Location_.Address + '","address2_of_consignor":"' + Location_."Address 2" + '","place_of_consignor":"' +
        Location_.City + '","pincode_of_consignor":"' + Location_."Post Code" + '","state_of_consignor":"' + State_.Description +
        '","actual_from_state_name":"' + State_.Description + '","gstin_of_consignee":"' + consignee_gstin + '","legal_name_of_consignee":"' + Cust.Name +
        '","address1_of_consignee":"' + consignee_address1 + '","address2_of_consignee":"' + consignee_address2 +
        '","place_of_consignee":"' + Cust.City + '","pincode_of_consignee":"' + Cust."Post Code" + '","state_of_supply":"' + StateCust.Description +
        '","actual_to_state_name":"' + StateCust.Description + '","transaction_type":"' + Rec."Transaction Type" + '","other_value":"' + '' +
        '","total_invoice_value":"' + FORMAT(0) + '","taxable_amount":"' + FORMAT(TotaltaxableAmtValue) + '","cgst_amount":"' +
        FORMAT(TotalCGSTAmt) + '","sgst_amount":"' + FORMAT(TotalSGSTAmt) + '","igst_amount":"' + FORMAT(TotalIGSTAmt) + '","cess_amount":"' +
        FORMAT(TotalCESSGSTAmt) + '","cess_nonadvol_value":"' + '0' + '","transporter_id":"' + Rec."Transport Vendor GSTIN" + '","transporter_name":"' +
        Rec."Transport Vendor Name" + '","transporter_document_number":"' + Rec."LR/RR No." + '","transporter_document_date":"' + Transport_Date + '","transportation_mode":"' +
        Rec."Transport Method" + '","transportation_distance":"' + FORMAT(Rec."Distance (Km)") + '","vehicle_number":"' +
        Rec."Vehicle No." + '","vehicle_type":"' + 'Regular' + '","generate_status":"' + '1' + '","data_source":"' + 'erp' + '","user_ref":"' + '' +
        '","location_code":"' + Location_.Code + '","eway_bill_status":"' + FORMAT(Rec."E-Way Bill Generate") + '","auto_print":"' + 'Y' + '","email":"' +
        Location_."E-Mail" + '"}';
        */

        Document_Date := FORMAT(Rec."Posting Date", 0, '<Day,2>/<Month,2>/<year4>');
        Transport_Date := FORMAT(Rec."LR/RR Date", 0, '<Day,2>/<Month,2>/<year4>');  //PCPL/NSW/EINV 052522 New Code Added LR Date not Exist in BC 19 Replace With posting date
        //This code for Live <<
        //Temp Comment
        //IF EWayBillDetail.GET(SalesInvHdr."No.") THEN BEGIN
        //Document_Date := FORMAT("Document Date", 0, '<Day,2>/<Month,2>/<year4>');
        //Transport_Date := FORMAT("LR/RR Date", 0, '<Day,2>/<Month,2>/<year4>');  //PCPL/NSW/EINV 052522 New Code Added LR Date not Exist in BC 19 Replace With posting date
        Headerdata := '{"baseURL":"' + GeneralLedgerSetup."EINV Base URL" + '","access_token":"' + GeneralLedgerSetup."Access Token" + '","userGstin":"' + Location_."GST Registration No." + '","supply_type":"' + Supply + '","sub_supply_type":"' + Subsupply +
         '","sub_supply_description":"' + SubSupplydescr + '","document_type":"' + DocumentType + '","document_number":"' + Rec."No." +
         '","document_date":"' + Document_Date + '","gstin_of_consignor":"' + Location_."GST Registration No." + '","legal_name_of_consignor":"' + Location_.Name +
         '","address1_of_consignor":"' + Location_.Address + '","address2_of_consignor":"' + Location_."Address 2" + '","place_of_consignor":"' +
         Location_.City + '","pincode_of_consignor":"' + Location_."Post Code" + '","state_of_consignor":"' + State_.Description +
         '","actual_from_state_name":"' + State_.Description + '","gstin_of_consignee":"' + consignee_gstin + '","legal_name_of_consignee":"' + Cust.Name/*consignee_name*/ +
         '","address1_of_consignee":"' + consignee_address1 + '","address2_of_consignee":"' + consignee_address2 +
         '","place_of_consignee":"' + Cust.City/*consignee_place*/ + '","pincode_of_consignee":"' + Cust."Post Code"/*consignee_pincode*/ + '","state_of_supply":"' + StateCust.Description/*consignee_StateofSupply*/ +
         '","actual_to_state_name":"' + StateCust.Description/*consignee_StateName*/ + '","transaction_type":"' + Rec."Transaction Type" + '","other_value":"' + '' +
         '","total_invoice_value":"' + FORMAT(0/*LineInvoiceAmt*/) + '","taxable_amount":"' + FORMAT(TotaltaxableAmtValue/*TotaltaxableAmtValue1*/) + '","cgst_amount":"' +
         FORMAT(TotalCGSTAmt) + '","sgst_amount":"' + FORMAT(TotalSGSTAmt) + '","igst_amount":"' + FORMAT(TotalIGSTAmt) + '","cess_amount":"' +
         FORMAT(TotalCESSGSTAmt) + '","cess_nonadvol_value":"' + '0' + '","transporter_id":"' + Rec."Transport Vendor GSTIN" + '","transporter_name":"' +
         Rec."Transport Vendor Name" + '","transporter_document_number":"' + Rec."LR/RR No." + '","transporter_document_date":"' + Transport_Date + '","transportation_mode":"' +  //LR/RR No. Not exist in BC 19
         Rec."Transport Method" + '","transportation_distance":"' + FORMAT(Rec."Distance (Km)") + '","vehicle_number":"' +
         Rec."Vehicle No." + '","vehicle_type":"' + 'Regular' + '","generate_status":"' + '1' + '","data_source":"' + 'erp' + '","user_ref":"' + '' +
         '","location_code":"' + Location_.Name + '","eway_bill_status":"' + FORMAT(Rec."E-Way Bill Generate") + '","auto_print":"' + 'Y' + '","email":"' +
         Location_."E-Mail" + '"}';
        //PCPL/0026


        // << This code for test
        // GeneralLedgerSetup.get();
        // Headerdata := '{"baseURL":"' + GeneralLedgerSetup."EINV Base URL" + '","access_token":"' + GeneralLedgerSetup."Access Token" + '","userGstin":"' + '05AAABB0639G1Z8' + '","supply_type":"' + Supply + '","sub_supply_type":"' + Subsupply +
        // '","sub_supply_description":"' + SubSupplydescr + '","document_type":"' + DocumentType + '","document_number":"' + Rec."No." +
        // '","document_date":"' + Document_Date + '","gstin_of_consignor":"' + '05AAABB0639G1Z8' + '","legal_name_of_consignor":"' + Location_.Name +
        // '","address1_of_consignor":"' + Location_.Address + '","address2_of_consignor":"' + Location_."Address 2" + '","place_of_consignor":"' +
        // Location_.City + '","pincode_of_consignor":"' + Location_."Post Code" + '","state_of_consignor":"' + State_.Description +
        // '","actual_from_state_name":"' + State_.Description + '","gstin_of_consignee":"' + '05AAABC0181E1ZE' + '","legal_name_of_consignee":"' + Cust.Name +
        // '","address1_of_consignee":"' + consignee_address1 + '","address2_of_consignee":"' + consignee_address2 +
        // '","place_of_consignee":"' + Cust.City + '","pincode_of_consignee":"' + Cust."Post Code" + '","state_of_supply":"' + StateCust.Description +
        // '","actual_to_state_name":"' + StateCust.Description + '","transaction_type":"' + Rec."Transaction Type" + '","other_value":"' + '' +
        // '","total_invoice_value":"' + FORMAT(0) + '","taxable_amount":"' + FORMAT(TotaltaxableAmtValue) + '","cgst_amount":"' +
        // FORMAT(TotalCGSTAmt) + '","sgst_amount":"' + FORMAT(TotalSGSTAmt) + '","igst_amount":"' + FORMAT(TotalIGSTAmt) + '","cess_amount":"' +
        // FORMAT(TotalCESSGSTAmt) + '","cess_nonadvol_value":"' + '0' + '","transporter_id":"' + '05AAABB0639G1Z8' + '","transporter_name":"' +
        // Rec."Transport Vendor Name" + '","transporter_document_number":"' + Rec."LR/RR No." + '","transporter_document_date":"' + Transport_Date + '","transportation_mode":"' +
        // Rec."Transport Method" + '","transportation_distance":"' + FORMAT(Rec."Distance (Km)") + '","vehicle_number":"' +
        // Rec."Vehicle No." + '","vehicle_type":"' + 'Regular' + '","generate_status":"' + '1' + '","data_source":"' + 'erp' + '","user_ref":"' + '' +
        // '","location_code":"' + Location_.Name + '","eway_bill_status":"' + FORMAT(Rec."E-Way Bill Generate") + '","auto_print":"' + 'Y' + '","email":"' +
        // Location_."E-Mail" + '"}';
        // >>

        //result := Ewaybill.GenerateEwaybill(GeneralLedgerSetup."EINV Base URL", token, Headerdata, Linedata, GeneralLedgerSetup."EINV Path");
        //Generate data in Json Object and assign to Content var

        //JsonEinvObject.Add('baseURL', GeneralLedgerSetup."EINV Base URL");
        JsonEinvObject.Add('baseURL', GeneralLedgerSetup."EINV Base URL");
        JsonEinvObject.Add('access_token', GeneralLedgerSetup."Access Token");
        JsonEinvObject.Add('userGstin', Location_."GST Registration No.");
        JsonEinvObject.Add('supply_type', Supply);
        JsonEinvObject.Add('sub_supply_type', Subsupply);
        JsonEinvObject.Add('sub_supply_description', SubSupplydescr);
        JsonEinvObject.Add('document_type', DocumentType);
        JsonEinvObject.Add('document_number', Rec."No.");
        JsonEinvObject.Add('document_date', Document_Date);
        JsonEinvObject.Add('gstin_of_consignor', Location_."GST Registration No.");
        JsonEinvObject.Add('legal_name_of_consignor', Location_.Name);
        JsonEinvObject.Add('address1_of_consignor', Location_.Address);
        JsonEinvObject.Add('address2_of_consignor', Location_."Address 2");
        JsonEinvObject.Add('place_of_consignor', Location_.City);
        JsonEinvObject.Add('pincode_of_consignor', Location_."Post Code");
        JsonEinvObject.Add('state_of_consignor', State_.Description);
        JsonEinvObject.Add('actual_from_state_name', State_.Description);
        JsonEinvObject.Add('gstin_of_consignee', consignee_gstin);
        JsonEinvObject.Add('legal_name_of_consignee', Cust.Name);
        JsonEinvObject.Add('address1_of_consignee', consignee_address1);
        JsonEinvObject.Add('address2_of_consignee', consignee_address2);
        JsonEinvObject.Add('place_of_consignee', Cust.City);
        JsonEinvObject.Add('pincode_of_consignee', Cust."Post Code");
        JsonEinvObject.Add('state_of_supply', StateCust.Description);
        JsonEinvObject.Add('actual_to_state_name', StateCust.Description);
        JsonEinvObject.Add('transaction_type', Rec."Transaction Type");
        JsonEinvObject.Add('other_value', '');
        JsonEinvObject.Add('total_invoice_value', FORMAT(0));
        JsonEinvObject.Add('taxable_amount', FORMAT(TotaltaxableAmtValue));
        JsonEinvObject.Add('cgst_amount', FORMAT(TotalCGSTAmt));
        JsonEinvObject.Add('sgst_amount', FORMAT(TotalSGSTAmt));
        JsonEinvObject.Add('igst_amount', FORMAT(TotalIGSTAmt));
        JsonEinvObject.Add('cess_amount', FORMAT(TotalCESSGSTAmt));
        JsonEinvObject.Add('cess_nonadvol_value', FORMAT(0));
        JsonEinvObject.Add('transporter_id', Rec."Transport Vendor GSTIN");
        JsonEinvObject.Add('transporter_name', Rec."Transport Vendor Name");
        JsonEinvObject.Add('transporter_document_number', Rec."LR/RR No.");
        JsonEinvObject.Add('transporter_document_date', Transport_Date);
        JsonEinvObject.Add('transportation_mode', Rec."Transport Method");
        JsonEinvObject.Add('transportation_distance', FORMAT(Rec."Distance (Km)"));
        JsonEinvObject.Add('vehicle_number', Rec."Vehicle No.");
        JsonEinvObject.Add('vehicle_type', 'Regular');
        JsonEinvObject.Add('generate_status', '1');
        JsonEinvObject.Add('data_source', 'erp');
        JsonEinvObject.Add('user_ref', '');
        JsonEinvObject.Add('location_code', Location_.Code);
        JsonEinvObject.Add('eway_bill_status', FORMAT(Rec."E-Way Bill Generate"));
        JsonEinvObject.Add('auto_print', 'Y');
        JsonEinvObject.Add('email', Location_."E-Mail");
        JsonEinvObject.Add('itemList', EwayJarray);
        //JsonEinvObject.Add('itemList', Linedata);
        //Message(Linedata);



        JsonEinvObject.WriteTo(EinvRequestTxt);
        //EinvRequestTxt := EinvRequestTxt.Replace('}"}', '}');
        //EinvRequestTxt := EinvRequestTxt.Replace('"[', '[');
        EinvRequestContent.WriteFrom(EinvRequestTxt);
        EinvRequestContent.GetHeaders(HttpHead);

        //<<************Request File Download code*************
        FileName := rec."No." + '_' + 'Requestfile' + '.txt';
        reqtempblob.CreateInStream(reqInStm);
        reqtempblob.CreateOutStream(reqOStm);
        JsonEinvObject.WriteTo(reqOStm);
        reqOStm.WriteText(EinvRequestTxt);
        reqInStm.ReadText(EinvRequestTxt);
        DownloadFromStream(ReqInStm, '', '', '', FileName);

        //*******************API Call Code****************************
        if client.Post(GeneralLedgerSetup."E-Way API Link", EinvRequestContent, EinvResponse) then begin
            if EinvResponse.IsSuccessStatusCode() then begin
                Einvcontent := EinvResponse.Content;
                Einvcontent.ReadAs(result);
                //EINVPos := COPYSTR(result, 1, 8);

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
                        EWayBillDetail."Transporter Name" := Rec."Transport Vendor Name";
                        EWayBillDetail."Transportation Mode" := Rec."Transport Method";
                        EWayBillDetail."Transport Distance" := Rec."Distance (Km)";
                        EWayBillDetail."Ewaybill Error" := '';
                        EWayBillDetail."E-Way Bill Generate" := EWayBillDetail."E-Way Bill Generate"::Generated;
                        EWayBillDetail.MODIFY;
                        //EWayBillDetail.Insert();
                        SalesInvHeader.Reset();
                        SalesInvHeader.SetRange("No.", Rec."No.");
                        IF SalesInvHeader.FindFirst() then begin
                            SalesInvHeader."E-Way Bill Generate" := SalesInvHeader."E-Way Bill Generate"::Generated;
                            SalesInvHeader.MODIFY;
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
            end else begin
                Einvcontent := EinvResponse.Content;
                Einvcontent.ReadAs(result);
                Error('E-Way Response: %1', result);
            end;
        end;
    end;
    //PCPL/NSW/EINV 050522
    procedure GetStatisticsPostedSalesInvAmount(
        SalesInvHeader: Record "Sales Invoice Header";
        var
            GSTAmount: Decimal;

    var
        AmountToCust: Decimal)
    var
        SalesInvLine: Record "Sales Invoice Line";
        TotalAmount: decimal;
    begin
        Clear(GSTAmount);

        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount(SalesInvLine.RecordId());
                TotalAmount += SalesInvLine."Line Amount" - SalesInvLine."Line Discount Amount";
            until SalesInvLine.Next() = 0;
        AmountToCust := GSTAmount + TotalAmount;
    end;

    local procedure GetGSTAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Amount);

        exit(TaxTransactionValue.Amount);
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

