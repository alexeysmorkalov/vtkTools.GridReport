unit vgr_StringIDs;

{$I vtk.inc}

interface

const

  svgrResStringsBase = 30000;
  svgrResStringsLastIndex = 475;


  svgrid_Common_MenuItemCut = 54;
  svgrid_Common_MenuItemCopy = 55;
  svgrid_Common_MenuItemPaste = 56;
  svgrid_Common_Mm = 411;
  svgrid_Common_Inch = 412;
  svgrid_Common_ColorButtonOther = 48;
  svgrid_Common_ColorButtonNone = 49;
  svgrid_vgr_CellPropertiesDialog_vgrhaAuto = 413;
  svgrid_vgr_CellPropertiesDialog_vgrhaLeft = 414;
  svgrid_vgr_CellPropertiesDialog_vgrhaCenter = 415;
  svgrid_vgr_CellPropertiesDialog_vgrhaRight = 416;
  svgrid_vgr_CellPropertiesDialog_vgrvaTop = 417;
  svgrid_vgr_CellPropertiesDialog_vgrvaCenter = 418;
  svgrid_vgr_CellPropertiesDialog_vgrvaBottom = 419;
  svgrid_Common_vgrbsSolid = 420;
  svgrid_Common_vgrbsDash = 421;
  svgrid_Common_vgrbsDot = 422;
  svgrid_Common_vgrbsDashDot = 423;
  svgrid_Common_vgrbsDashDotDot = 424;
  svgrid_Common_bsSolid = 425;
  svgrid_Common_bsClear = 426;
  svgrid_Common_bsHorizontal = 427;
  svgrid_Common_bsVertical = 428;
  svgrid_Common_bsFDiagonal = 429;
  svgrid_Common_bsBDiagonal = 430;
  svgrid_Common_bsCross = 431;
  svgrid_Common_bsDiagCross = 432;
  svgrid_Common_vgruMms = 433;
  svgrid_Common_vgruCentimeters = 434;
  svgrid_Common_vgruInches = 435;
  svgrid_Common_vgruTenthsMMs = 436;
  svgrid_Common_vgruPixels = 437;
  svgrid_vgr_AliasManagerDesigner_NodeValueTypeNull = 0;
  svgrid_vgr_AliasManagerDesigner_NodeValueTypeInteger = 1;
  svgrid_vgr_AliasManagerDesigner_NodeValueTypeExtended = 2;
  svgrid_vgr_AliasManagerDesigner_NodeValueTypeString = 3;
  svgrid_vgr_AliasManagerDesigner_NodeValueTypeDateTime = 4;
  svgrid_vgr_AliasManagerDesigner_ErrorNodeNameEmpty = 5;
  svgrid_vgr_AliasManagerDesigner_ErrorNodeNameNotUnique = 6;
  svgrid_vgr_BandFormatDialog_InvalidBandName = 7;
  svgrid_vgr_BandFormatDialog_InvalidBandStartPos = 8;
  svgrid_vgr_BandFormatDialog_InvalidBandEndPos = 9;
  svgrid_vgr_BandFormatDialog_InvalidBandPosition = 10;
  svgrid_vgr_CellPropertiesDialog_MergeWarning = 11;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryNumeric = 365;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryDate = 366;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryTime = 367;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryDateTime = 368;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryText = 369;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryAll = 370;
  svgrid_vgr_CellPropertiesDialog_FormatCategoryCommon = 371;
  svgrid_vgr_CellPropertiesDialog_SelectCategoryMessage = 372;
  svgrid_vgr_CellPropertiesDialog_NoFormatMessage = 373;
  svgrid_vgr_FormulaCalculator_StackPopError = 12;
  svgrid_vgr_FormulaCalculator_InvalidOperandType = 13;
  svgrid_vgr_FormulaCalculator_InvalidOperands = 14;
  svgrid_vgr_FormulaCalculator_DivideByZero = 15;
  svgrid_vgr_FormulaCalculator_InvalidFunctionIndex = 16;
  svgrid_vgr_FormulaCalculator_InvalidFunctionParamsCount = 17;
  svgrid_vgr_FormulaCalculator_InvalidCellReference = 18;
  svgrid_vgr_ExcelFormula_InvalidCellReference = svgrid_vgr_FormulaCalculator_InvalidCellReference;
  svgrid_vgr_PageSetupDialog_HF_Page = 448;
  svgrid_vgr_PageSetupDialog_HF_PageOf = 449;
  svgrid_vgr_PageSetupDialog_MetricSystem = 19;
  svgrid_vgr_PageSetupDialog_USASystem = 20;
  svgrid_vgr_PageSetupDialog_PaperSizeCaptionMask = 21;
  svgrid_vgr_PrintSetupDialog_InvalidPagesRange = 22;
  svgrid_vgr_PrintSetupDialog_InvalidPagesList = 23;
  svgrid_vgr_PrintSetupDialog_PrintWorksheetNotDefined = 24;
  svgrid_vgr_PropertyEditors_EditWorkbook = 25;
  svgrid_vgr_PropertyEditors_EditTemplate = 26;
  svgrid_vgr_PropertyEditors_AliasManager = 27;
  svgrid_vgr_ReportDesigner_SaveChanges = 28;
  svgrid_vgr_ReportDesigner_NewTemplateCaption = 29;
  svgrid_vgr_ReportDesigner_ReportTabSheetCaption = 30;
  svgrid_vgr_ReportDesigner_TemplateOpenSaveDialogFilter = 31;
  svgrid_vgr_ReportDesigner_TemplateOpenSaveDefaultExt = 32;
  svgrid_vgr_ReportDesigner_ReportTreeNodeCaption = 33;
  svgrid_vgr_ReportDesigner_HorzBandsTreeNodeCaption = 34;
  svgrid_vgr_ReportDesigner_VertBandsTreeNodeCaption = 35;
  svgrid_vgr_ReportDesigner_Insert = 36;
  svgrid_vgr_ReportDesigner_Overwrite = 37;
  svgrid_vgr_SheetFormatDialog_InvalidSheetName = 38;
  svgrid_vgr_WorkbookDesigner_SaveChanges = 39;
  svgrid_vgr_WorkbookDesigner_NewDocCaption = 40;
  svgrid_vgr_WorkbookDesigner_WorkbookTabSheetCaption = 41;
  svgrid_vgr_WorkbookDesigner_DeleteLastSheetErrorMessage = 42;
  svgrid_vgr_WorkbookDesigner_DeleteNotEmptySheetWarning = 43;
  svgrid_vgr_WorkbookDesigner_RowHeightFormCaption = 44;
  svgrid_vgr_WorkbookDesigner_RowHeightFormText = 45;
  svgrid_vgr_WorkbookDesigner_ColWidthFormCaption = 46;
  svgrid_vgr_WorkbookDesigner_ColWidthFormText = 47;
  svgrid_vgr_WorkbookDesigner_WorkbookOpenSaveDialogFilter = 50;
  svgrid_vgr_WorkbookDesigner_WorkbookOpenSaveDefaultExt = 51;
  svgrid_vgr_WorkbookDesigner_Modified = 52;
  svgrid_vgr_WorkbookDesigner_NotModified = 53;
  svgrid_vgr_WorkbookGrid_MenuItemDeleteRows = 57;
  svgrid_vgr_WorkbookGrid_MenuItemDeleteColumns = 58;
  svgrid_vgr_WorkbookGrid_MenuItemCellProperties = 59;
  svgrid_vgr_WorkbookGrid_MergeWarning = 60;
  svgrid_vgr_WorkbookGrid_MenuItemPrintAsPageHeader = 61;
  svgrid_vgr_WorkbookGrid_MenuItemPrintAsPageFooter = 62;
  svgrid_vgr_WorkbookGrid_MenuItemPrintWithNextSection = 63;
  svgrid_vgr_WorkbookGrid_MenuItemPrintWithPreviosSection = 64;
  svgrid_vgr_WorkbookGrid_MenuItemBreakPageAfter = 65;
  svgrid_vgr_WorkbookGrid_MenuItemRowsAutoHeight = 66;
  svgrid_vgr_WorkbookGrid_MenuItemColumnsAutoWidth = 67;
  svgrid_vgr_WorkbookGrid_MenuItemAddWorksheet = 68;
  svgrid_vgr_WorkbookGrid_MenuItemInsertWorksheet = 69;
  svgrid_vgr_WorkbookGrid_MenuItemCopyMoveWorksheet = 70;
  svgrid_vgr_WorkbookGrid_MenuItemDeleteWorksheet = 71;
  svgrid_vgr_WorkbookGrid_MenuItemRenameWorksheet = 72;
  svgrid_vgr_WorkbookGrid_DeleteWorksheetQuestion = 73;
  svgrid_vgr_WorkbookPreviewForm_StatusBarFormatMask = 74;
  svgrid_vgr_WorkbookPreview_MenuItemZoomPageWidth = 75;
  svgrid_vgr_WorkbookPreview_MenuItemZoomWholePage = 76;
  svgrid_vgr_WorkbookPreview_MenuItemZoom100Percent = 77;
  svgrid_vgr_WorkbookPreview_MenuItemPriorPage = 78;
  svgrid_vgr_WorkbookPreview_MenuItemNextPage = 79;
  svgrid_vgr_WorkbookPreview_MenuItemPrint = 80;
  svgrid_vgr_WorkbookPreview_MenuItemPageParams = 81;
  svgrid__vgr_AliasManagerDesigner__vgrAliasManagerDesignerForm__Caption = 82;
  svgrid__vgr_AliasManagerDesigner__Label1__Caption = 83;
  svgrid__vgr_AliasManagerDesigner__bClose__Caption = 84;
  svgrid__vgr_AliasManagerDesigner__bCancel__Caption = 85;
  svgrid__vgr_AliasManagerDesigner__bApply__Caption = 86;
  svgrid__vgr_AliasManagerDesigner__bOptions__Caption = 87;
  svgrid__vgr_AliasManagerDesigner__bAdd__Caption = 88;
  svgrid__vgr_AliasManagerDesigner__bAddChild__Caption = 89;
  svgrid__vgr_AliasManagerDesigner__bDelete__Caption = 90;
  svgrid__vgr_AliasManagerDesigner__rbUnknown__Caption = 91;
  svgrid__vgr_AliasManagerDesigner__rbCustom__Caption = 92;
  svgrid__vgr_AliasManagerDesigner__rbVariable__Caption = 93;
  svgrid__vgr_AliasManagerDesigner__mShowAllComponents__Caption = 94;
  svgrid__vgr_AliasManagerDesigner__mShowDatasetsOnly__Caption = 95;
  svgrid__vgr_AliasManagerDesigner__mImport__Caption = 96;
  svgrid__vgr_BandFormatDialog__vgrBandFormatForm__Caption = 97;
  svgrid__vgr_BandFormatDialog__Label1__Caption = 98;
  svgrid__vgr_BandFormatDialog__Label2__Caption = 99;
  svgrid__vgr_BandFormatDialog__Label3__Caption = 100;
  svgrid__vgr_BandFormatDialog__Label4__Caption = 101;
  svgrid__vgr_BandFormatDialog__Label5__Caption = 102;
  svgrid__vgr_BandFormatDialog__Label6__Caption = 103;
  svgrid__vgr_BandFormatDialog__PCommon__Caption = 104;
  svgrid__vgr_BandFormatDialog__PData__Caption = 105;
  svgrid__vgr_BandFormatDialog__cbSkipGenerate__Caption = 106;
  svgrid__vgr_BandFormatDialog__GroupBox1__Caption = 107;
  svgrid__vgr_BandFormatDialog__bOk__Caption = 108;
  svgrid__vgr_BandFormatDialog__bCancel__Caption = 109;
  svgrid__vgr_CellPropertiesDialog__vgrCellPropertiesForm__Caption = 110;
  svgrid__vgr_CellPropertiesDialog__bOk__Caption = 111;
  svgrid__vgr_CellPropertiesDialog__bCancel__Caption = 112;
  svgrid__vgr_CellPropertiesDialog__Alignment__Caption = 113;
  svgrid__vgr_CellPropertiesDialog__TabSheet1__Caption = 114;
  svgrid__vgr_CellPropertiesDialog__TabSheet2__Caption = 115;
  svgrid__vgr_CellPropertiesDialog__Patterns__Caption = 116;
  svgrid__vgr_CellPropertiesDialog__Label1__Caption = 117;
  svgrid__vgr_CellPropertiesDialog__Label6__Caption = 118;
  svgrid__vgr_CellPropertiesDialog__Label14__Caption = 119;
  svgrid__vgr_CellPropertiesDialog__Label16__Caption = 120;
  svgrid__vgr_CellPropertiesDialog__Label22__Caption = 121;
  svgrid__vgr_CellPropertiesDialog__Label3__Caption = 122;
  svgrid__vgr_CellPropertiesDialog__Label4__Caption = 123;
  svgrid__vgr_CellPropertiesDialog__Label2__Caption = 124;
  svgrid__vgr_CellPropertiesDialog__Label5__Caption = 125;
  svgrid__vgr_CellPropertiesDialog__Label7__Caption = 126;
  svgrid__vgr_CellPropertiesDialog__Label8__Caption = 127;
  svgrid__vgr_CellPropertiesDialog__Label9__Caption = 128;
  svgrid__vgr_CellPropertiesDialog__Label10__Caption = 129;
  svgrid__vgr_CellPropertiesDialog__Label24__Caption = 130;
  svgrid__vgr_CellPropertiesDialog__FontPreview__Caption = 131;
  svgrid__vgr_CellPropertiesDialog__Label20__Caption = 132;
  svgrid__vgr_CellPropertiesDialog__Label17__Caption = 133;
  svgrid__vgr_CellPropertiesDialog__Label18__Caption = 134;
  svgrid__vgr_CellPropertiesDialog__Label19__Caption = 135;
  svgrid__vgr_CellPropertiesDialog__Label21__Caption = 136;
  svgrid__vgr_CellPropertiesDialog__Label11__Caption = 137;
  svgrid__vgr_CellPropertiesDialog__Label12__Caption = 138;
  svgrid__vgr_CellPropertiesDialog__Label13__Caption = 139;
  svgrid__vgr_CellPropertiesDialog__Label15__Caption = 140;
  svgrid__vgr_CellPropertiesDialog__Label23__Caption = 141;
  svgrid__vgr_CellPropertiesDialog__bDefault__Caption = 142;
  svgrid__vgr_CellPropertiesDialog__cbWrapText__Caption = 143;
  svgrid__vgr_CellPropertiesDialog__cbMergeCells__Caption = 144;
  svgrid__vgr_CellPropertiesDialog__cbFontStyleBold__Caption = 145;
  svgrid__vgr_CellPropertiesDialog__cbFontStyleItalic__Caption = 146;
  svgrid__vgr_CellPropertiesDialog__cbFontStyleUnderline__Caption = 147;
  svgrid__vgr_CellPropertiesDialog__cbFontStyleStrikeout__Caption = 148;
  svgrid__vgr_CellPropertiesDialog__GroupBox1__Caption = 149;
  svgrid__vgr_CellPropertiesDialog__GroupBox3__Caption = 150;
  svgrid__vgr_CellPropertiesDialog__GroupBox4__Caption = 151;
  svgrid__vgr_CellPropertiesDialog__GroupBox2__Caption = 152;
  svgrid__vgr_CopyMoveSheetDialog__vgrCopyMoveSheetDialogForm__Caption = 153;
  svgrid__vgr_CopyMoveSheetDialog__Label1__Caption = 154;
  svgrid__vgr_CopyMoveSheetDialog__Label2__Caption = 155;
  svgrid__vgr_CopyMoveSheetDialog__lSelectedSheet__Caption = 156;
  svgrid__vgr_CopyMoveSheetDialog__cbCreateCopy__Caption = 157;
  svgrid__vgr_CopyMoveSheetDialog__bOk__Caption = 158;
  svgrid__vgr_CopyMoveSheetDialog__bCancel__Caption = 159;
  svgrid__vgr_PageSetupDialog__vgrPageSetupDialogForm__Caption = 160;
  svgrid__vgr_PageSetupDialog__Label1__Caption = 161;
  svgrid__vgr_PageSetupDialog__Label3__Caption = 162;
  svgrid__vgr_PageSetupDialog__Label6__Caption = 163;
  svgrid__vgr_PageSetupDialog__Label7__Caption = 164;
  svgrid__vgr_PageSetupDialog__Label8__Caption = 165;
  svgrid__vgr_PageSetupDialog__Label9__Caption = 166;
  svgrid__vgr_PageSetupDialog__Label10__Caption = 167;
  svgrid__vgr_PageSetupDialog__Label11__Caption = 168;
  svgrid__vgr_PageSetupDialog__Label12__Caption = 169;
  svgrid__vgr_PageSetupDialog__Label13__Caption = 170;
  svgrid__vgr_PageSetupDialog__Label16__Caption = 171;
  svgrid__vgr_PageSetupDialog__Label17__Caption = 172;
  svgrid__vgr_PageSetupDialog__Label15__Caption = 173;
  svgrid__vgr_PageSetupDialog__PPage__Caption = 174;
  svgrid__vgr_PageSetupDialog__PMargins__Caption = 175;
  svgrid__vgr_PageSetupDialog__PDefaults__Caption = 176;
  svgrid__vgr_PageSetupDialog__Label2__Caption = 177;
  svgrid__vgr_PageSetupDialog__Label4__Caption = 178;
  svgrid__vgr_PageSetupDialog__Label5__Caption = 179;
  svgrid__vgr_PageSetupDialog__Label14__Caption = 180;
  svgrid__vgr_PageSetupDialog__rbPredefinedPageSize__Caption = 181;
  svgrid__vgr_PageSetupDialog__rbCustomPageSize__Caption = 182;
  svgrid__vgr_PageSetupDialog__rbPagePortrait__Caption = 183;
  svgrid__vgr_PageSetupDialog__rbPageLandscape__Caption = 184;
  svgrid__vgr_PageSetupDialog__bOk__Caption = 185;
  svgrid__vgr_PageSetupDialog__bCancel__Caption = 186;
  svgrid__vgr_PrintSetupDialog__vgrPrintSetupDialogForm__Caption = 187;
  svgrid__vgr_PrintSetupDialog__vgrBevelLabel1__Caption = 188;
  svgrid__vgr_PrintSetupDialog__vgrBevelLabel2__Caption = 189;
  svgrid__vgr_PrintSetupDialog__vgrBevelLabel3__Caption = 190;
  svgrid__vgr_PrintSetupDialog__vgrBevelLabel4__Caption = 191;
  svgrid__vgr_PrintSetupDialog__Label1__Caption = 192;
  svgrid__vgr_PrintSetupDialog__Label2__Caption = 193;
  svgrid__vgr_PrintSetupDialog__Label3__Caption = 194;
  svgrid__vgr_PrintSetupDialog__Label4__Caption = 195;
  svgrid__vgr_PrintSetupDialog__Label5__Caption = 196;
  svgrid__vgr_PrintSetupDialog__Label6__Caption = 197;
  svgrid__vgr_PrintSetupDialog__Label7__Caption = 198;
  svgrid__vgr_PrintSetupDialog__bProperties__Caption = 199;
  svgrid__vgr_PrintSetupDialog__bOk__Caption = 200;
  svgrid__vgr_PrintSetupDialog__bCancel__Caption = 201;
  svgrid__vgr_PrintSetupDialog__rbWorksheetModeAll__Caption = 202;
  svgrid__vgr_PrintSetupDialog__rbWorksheetModeOne__Caption = 203;
  svgrid__vgr_PrintSetupDialog__rbPageModeAll__Caption = 204;
  svgrid__vgr_PrintSetupDialog__rbPageModeRange__Caption = 205;
  svgrid__vgr_PrintSetupDialog__rbPageModeCurrent__Caption = 206;
  svgrid__vgr_PrintSetupDialog__rbPageModeList__Caption = 207;
  svgrid__vgr_PrintSetupDialog__cbCollate__Caption = 208;
  svgrid__vgr_ReportOptionsDialog__vgrReportOptionsDialogForm__Caption = 209;
  svgrid__vgr_ReportOptionsDialog__PScript__Caption = 210;
  svgrid__vgr_ReportOptionsDialog__Label1__Caption = 211;
  svgrid__vgr_ReportOptionsDialog__bOk__Caption = 212;
  svgrid__vgr_ReportOptionsDialog__bCancel__Caption = 213;
  svgrid__vgr_RowColSizeDialog__bOk__Caption = 214;
  svgrid__vgr_RowColSizeDialog__bCancel__Caption = 215;
  svgrid__vgr_ScriptEventEditDialog__vgrScriptEventEditForm__Caption = 216;
  svgrid__vgr_ScriptEventEditDialog__Label1__Caption = 217;
  svgrid__vgr_ScriptEventEditDialog__Label2__Caption = 218;
  svgrid__vgr_ScriptEventEditDialog__bOK__Caption = 219;
  svgrid__vgr_ScriptEventEditDialog__bCancel__Caption = 220;
  svgrid__vgr_SheetFormatDialog__vgrSheetFormatForm__Caption = 221;
  svgrid__vgr_SheetFormatDialog__Label1__Caption = 222;
  svgrid__vgr_SheetFormatDialog__Label2__Caption = 223;
  svgrid__vgr_SheetFormatDialog__bOk__Caption = 224;
  svgrid__vgr_SheetFormatDialog__bCancel__Caption = 225;
  svgrid__vgr_WorkbookPreviewForm__vgrWorkbookPreviewForm__Caption = 226;
  svgrid__vgr_WorkbookPreviewForm__aPrint__Caption = 227;
  svgrid__vgr_WorkbookPreviewForm__aPrint__Hint = 228;
  svgrid__vgr_WorkbookPreviewForm__aEditPageParams__Caption = 229;
  svgrid__vgr_WorkbookPreviewForm__aEditPageParams__Hint = 230;
  svgrid__vgr_WorkbookPreviewForm__aZoomPageWidth__Caption = 231;
  svgrid__vgr_WorkbookPreviewForm__aZoomPageWidth__Hint = 232;
  svgrid__vgr_WorkbookPreviewForm__aZoomWholePage__Caption = 233;
  svgrid__vgr_WorkbookPreviewForm__aZoomWholePage__Hint = 234;
  svgrid__vgr_WorkbookPreviewForm__aZoom100Percent__Caption = 235;
  svgrid__vgr_WorkbookPreviewForm__aZoom100Percent__Hint = 236;
  svgrid__vgr_WorkbookPreviewForm__aFirstPage__Caption = 237;
  svgrid__vgr_WorkbookPreviewForm__aFirstPage__Hint = 238;
  svgrid__vgr_WorkbookPreviewForm__aPriorPage__Caption = 239;
  svgrid__vgr_WorkbookPreviewForm__aPriorPage__Hint = 240;
  svgrid__vgr_WorkbookPreviewForm__aNextPage__Caption = 241;
  svgrid__vgr_WorkbookPreviewForm__aNextPage__Hint = 242;
  svgrid__vgr_WorkbookPreviewForm__aLastPage__Caption = 243;
  svgrid__vgr_WorkbookPreviewForm__aLastPage__Hint = 244;
  svgrid__vgr_WorkbookDesigner__vgrWorkbookDesignerForm__Caption = 245;
  svgrid__vgr_WorkbookDesigner__tbStandard__Caption = 246;
  svgrid__vgr_WorkbookDesigner__tbFormatting__Caption = 247;
  svgrid__vgr_WorkbookDesigner__PGrid__Caption = 248;
  svgrid__vgr_WorkbookDesigner__File1__Caption = 249;
  svgrid__vgr_WorkbookDesigner__Edit1__Caption = 250;
  svgrid__vgr_WorkbookDesigner__Clear1__Caption = 251;
  svgrid__vgr_WorkbookDesigner__View1__Caption = 252;
  svgrid__vgr_WorkbookDesigner__mToolbars__Caption = 253;
  svgrid__vgr_WorkbookDesigner__Insert1__Caption = 254;
  svgrid__vgr_WorkbookDesigner__Format1__Caption = 255;
  svgrid__vgr_WorkbookDesigner__Row2__Caption = 256;
  svgrid__vgr_WorkbookDesigner__Column2__Caption = 257;
  svgrid__vgr_WorkbookDesigner__Sheet2__Caption = 258;
  svgrid__vgr_WorkbookDesigner__aOpen__Caption = 259;
  svgrid__vgr_WorkbookDesigner__aOpen__Hint = 260;
  svgrid__vgr_WorkbookDesigner__aNew__Caption = 261;
  svgrid__vgr_WorkbookDesigner__aNew__Hint = 262;
  svgrid__vgr_WorkbookDesigner__aSave__Caption = 263;
  svgrid__vgr_WorkbookDesigner__aSave__Hint = 264;
  svgrid__vgr_WorkbookDesigner__aSaveAs__Caption = 265;
  svgrid__vgr_WorkbookDesigner__aSaveAs__Hint = 266;
  svgrid__vgr_WorkbookDesigner__aExit__Caption = 267;
  svgrid__vgr_WorkbookDesigner__aExit__Hint = 268;
  svgrid__vgr_WorkbookDesigner__aCut__Caption = 269;
  svgrid__vgr_WorkbookDesigner__aCut__Hint = 270;
  svgrid__vgr_WorkbookDesigner__aCopy__Caption = 271;
  svgrid__vgr_WorkbookDesigner__aCopy__Hint = 272;
  svgrid__vgr_WorkbookDesigner__aPaste__Caption = 273;
  svgrid__vgr_WorkbookDesigner__aPaste__Hint = 274;
  svgrid__vgr_WorkbookDesigner__aPageSetup__Caption = 275;
  svgrid__vgr_WorkbookDesigner__aPageSetup__Hint = 276;
  svgrid__vgr_WorkbookDesigner__aPrintPreview__Caption = 277;
  svgrid__vgr_WorkbookDesigner__aPrintPreview__Hint = 278;
  svgrid__vgr_WorkbookDesigner__aDelRow__Caption = 279;
  svgrid__vgr_WorkbookDesigner__aDelRow__Hint = 280;
  svgrid__vgr_WorkbookDesigner__aDelCol__Caption = 281;
  svgrid__vgr_WorkbookDesigner__aDelCol__Hint = 282;
  svgrid__vgr_WorkbookDesigner__aDelSheet__Caption = 283;
  svgrid__vgr_WorkbookDesigner__aDelSheet__Hint = 284;
  svgrid__vgr_WorkbookDesigner__aInsertRow__Caption = 285;
  svgrid__vgr_WorkbookDesigner__aInsertRow__Hint = 286;
  svgrid__vgr_WorkbookDesigner__aInsertColumn__Caption = 287;
  svgrid__vgr_WorkbookDesigner__aInsertSheet__Caption = 288;
  svgrid__vgr_WorkbookDesigner__aInsertSheet__Hint = 289;
  svgrid__vgr_WorkbookDesigner__aFormatCell__Caption = 290;
  svgrid__vgr_WorkbookDesigner__aFormatCell__Hint = 291;
  svgrid__vgr_WorkbookDesigner__aRowHeight__Caption = 292;
  svgrid__vgr_WorkbookDesigner__aRowHeight__Hint = 293;
  svgrid__vgr_WorkbookDesigner__aRowAutoHeight__Caption = 294;
  svgrid__vgr_WorkbookDesigner__aRowAutoHeight__Hint = 295;
  svgrid__vgr_WorkbookDesigner__aRowHide__Caption = 296;
  svgrid__vgr_WorkbookDesigner__aRowHide__Hint = 297;
  svgrid__vgr_WorkbookDesigner__aRowShow__Caption = 298;
  svgrid__vgr_WorkbookDesigner__aRowShow__Hint = 299;
  svgrid__vgr_WorkbookDesigner__aColWidth__Caption = 300;
  svgrid__vgr_WorkbookDesigner__aColWidth__Hint = 301;
  svgrid__vgr_WorkbookDesigner__aColAutoWidth__Caption = 302;
  svgrid__vgr_WorkbookDesigner__aColAutoWidth__Hint = 303;
  svgrid__vgr_WorkbookDesigner__aColHide__Caption = 304;
  svgrid__vgr_WorkbookDesigner__aColHide__Hint = 305;
  svgrid__vgr_WorkbookDesigner__aColShow__Caption = 306;
  svgrid__vgr_WorkbookDesigner__aColShow__Hint = 307;
  svgrid__vgr_WorkbookDesigner__aSheetRename__Caption = 308;
  svgrid__vgr_WorkbookDesigner__aSheetRename__Hint = 309;
  svgrid__vgr_WorkbookDesigner__aFontBold__Caption = 310;
  svgrid__vgr_WorkbookDesigner__aFontBold__Hint = 311;
  svgrid__vgr_WorkbookDesigner__aFontItalic__Caption = 312;
  svgrid__vgr_WorkbookDesigner__aFontItalic__Hint = 313;
  svgrid__vgr_WorkbookDesigner__aFontUnderline__Caption = 314;
  svgrid__vgr_WorkbookDesigner__aFontUnderline__Hint = 315;
  svgrid__vgr_WorkbookDesigner__aAlignLeft__Caption = 316;
  svgrid__vgr_WorkbookDesigner__aAlignLeft__Hint = 317;
  svgrid__vgr_WorkbookDesigner__aAlignHorzCenter__Caption = 318;
  svgrid__vgr_WorkbookDesigner__aAlignHorzCenter__Hint = 319;
  svgrid__vgr_WorkbookDesigner__aAlignRight__Caption = 320;
  svgrid__vgr_WorkbookDesigner__aAlignRight__Hint = 321;
  svgrid__vgr_WorkbookDesigner__aMerge__Caption = 322;
  svgrid__vgr_WorkbookDesigner__aMerge__Hint = 323;
  svgrid__vgr_WorkbookDesigner__aFormatCurrency__Caption = 324;
  svgrid__vgr_WorkbookDesigner__aFormatCurrency__Hint = 325;
  svgrid__vgr_WorkbookDesigner__aFormatPercent__Caption = 326;
  svgrid__vgr_WorkbookDesigner__aFormatPercent__Hint = 327;
  svgrid__vgr_WorkbookDesigner__aFormatSeparator__Caption = 328;
  svgrid__vgr_WorkbookDesigner__aFormatSeparator__Hint = 408;
  svgrid__vgr_WorkbookDesigner__aFormatDownDec__Caption = 329;
  svgrid__vgr_WorkbookDesigner__aFormatDownDec__Hint = 330;
  svgrid__vgr_WorkbookDesigner__aFormatUpDec__Caption = 331;
  svgrid__vgr_WorkbookDesigner__aFormatUpDec__Hint = 332;
  svgrid__vgr_WorkbookDesigner__aFillBackColor__Caption = 333;
  svgrid__vgr_WorkbookDesigner__aFillBackColor__Hint = 334;
  svgrid__vgr_WorkbookDesigner__aFontColor__Caption = 335;
  svgrid__vgr_WorkbookDesigner__aFontColor__Hint = 336;
  svgrid__vgr_WorkbookDesigner__aClearAll__Caption = 337;
  svgrid__vgr_WorkbookDesigner__aClearAll__Hint = 338;
  svgrid__vgr_WorkbookDesigner__aClearAllFormats__Caption = 339;
  svgrid__vgr_WorkbookDesigner__aClearDisplayFormat__Caption = 340;
  svgrid__vgr_WorkbookDesigner__aClearValue__Caption = 341;
  svgrid__vgr_WorkbookDesigner__aClearBorders__Caption = 342;
  svgrid__vgr_WorkbookDesigner__aViewHeaders__Caption = 343;
  svgrid__vgr_WorkbookDesigner__aViewHeaders__Hint = 344;
  svgrid__vgr_WorkbookDesigner__aViewFormula__Caption = 345;
  svgrid__vgr_WorkbookDesigner__aViewFormula__Hint = 346;
  svgrid__vgr_WorkbookDesigner__aOptions__Caption = 347;
  svgrid__vgr_WorkbookDesigner__aOptions__Hint = 348;
  svgrid__vgr_ReportDesigner__tbScript__Caption = 349;
  svgrid__vgr_ReportDesigner__PScript__Caption = 350;
  svgrid__vgr_ReportDesigner__mInsertHorzBand__Caption = 351;
  svgrid__vgr_ReportDesigner__mInsertVertBand__Caption = 352;
  svgrid__vgr_ReportDesigner__aReportOptions__Caption = 353;
  svgrid__vgr_ReportDesigner__aReportOptions__Hint = 354;
  svgrid__vgr_ReportDesigner__aFormatHorzBand__Caption = 355;
  svgrid__vgr_ReportDesigner__aFormatHorzBand__Hint = 356;
  svgrid__vgr_ReportDesigner__aFormatVertBand__Caption = 357;
  svgrid__vgr_ReportDesigner__aFormatVertBand__Hint = 358;
  svgrid__vgr_ReportDesigner__aSyntaxCheck__Caption = 359;
  svgrid__vgr_ReportDesigner__aSyntaxCheck__Hint = 360;
  svgrid__vgr_ReportDesigner__aProperties__Caption = 361;
  svgrid__vgr_ReportDesigner__aProperties__Hint = 362;
  svgrid__vgr_ReportDesigner__aDeleteEvent__Caption = 363;
  svgrid__vgr_ReportDesigner__aDeleteEvent__Hint = 364;
  svgrid__vgr_CellPropertiesDialog__bAddFormat__Caption = 374;
  svgrid__vgr_CellPropertiesDialog__bDeleteFormat__Caption = 375;
  svgrid__vgr_CellPropertiesDialog__Formats__Caption = 376;
  svgrid__vgr_CellPropertiesDialog__vgrBevelLabel1__Caption = 377;
  svgrid__vgr_CellPropertiesDialog__vgrBevelLabel2__Caption = 378;
  svgrid__vgr_CellPropertiesDialog__Label26__Caption = 379;
  svgrid__vgr_CellPropertiesDialog__GroupBox5__Caption = 380;
  svgrid__vgr_ReportDesigner__vgrReportDesignerForm__Caption = 381;
  svgrid__vgr_PrinterComboBox__NoInstalledPrinters = 382;
  svgrid_vgr_ScriptControl_Error_run_procedure = 383;
  svgrid_vgr_WorkbookPreview_MenuItemZoomInTool = 384;
  svgrid_vgr_WorkbookPreview_MenuItemZoomOutTool = 385;
  svgrid_vgr_WorkbookPreview_MenuItemHandTool = 386;
  svgrid__vgr_WorkbookPreviewForm__aHandTool__Caption = 387;
  svgrid__vgr_WorkbookPreviewForm__aHandTool__Hint = 388;
  svgrid__vgr_WorkbookPreviewForm__aZoomInTool__Caption = 389;
  svgrid__vgr_WorkbookPreviewForm__aZoomInTool__Hint = 390;
  svgrid__vgr_WorkbookPreviewForm__aZoomOutTool__Caption = 391;
  svgrid__vgr_WorkbookPreviewForm__aZoomOutTool__Hint = 392;
  svgrid_vgr_WorkbookPreview_MenuItemNoneTool = 393;
  svgrid__vgr_WorkbookPreviewForm__aNoneTool__Caption = 394;
  svgrid__vgr_WorkbookPreviewForm__aNoneTool__Hint = 395;
  svgrid_vgr_WorkbookPreview_Hint_LeftMargin = 398;
  svgrid_vgr_WorkbookPreview_Hint_RightMargin = 399;
  svgrid_vgr_WorkbookPreview_Hint_TopMargin = 400;
  svgrid_vgr_WorkbookPreview_Hint_BottomMargin = 401;
  svgrid__vgr_WorkbookPreviewForm__CloseSpeedButton__Hint = 402;
  svgrid__vgr_WorkbookPreviewForm__CloseSpeedButton__Caption = 403;
  svgrid_vgr_WorkbookPreview_MenuItemZoomTwoPages = 404;
  svgrid__vgr_WorkbookPreviewForm__aZoomTwoPages__Caption = 405;
  svgrid__vgr_WorkbookPreviewForm__aZoomTwoPages__Hint = 406;
  svgrid__vgr_WorkbookPreviewForm__MultiPageButton__Hint = 407;
  svgrid__vgr_WorkbookPreviewForm__MultiPageButton__CloseCaption = 409;
  svgrid__vgr_WorkbookPreviewForm__MultiPageButton__PagesCaption = 410;
  svgrid_vgr_ScriptControl_Error_constant_already_exists = 438;
  svgrid__vgr_ReportSheetFormatDialog__vgrReportSheetFormatForm__Caption = 439;
  svgrid__vgr_ReportSheetFormatDialog__gbBounds__Caption = 440;
  svgrid__vgr_ReportSheetFormatDialog__cbAutoBounds__Caption = 441;
  svgrid__vgr_ReportSheetFormatDialog__cbSkipGenerate__Caption = 442;
  svgrid__vgr_ReportSheetFormatDialog__Label1__Caption = 443;
  svgrid__vgr_ReportSheetFormatDialog__Label2__Caption = 444;
  svgrid__vgr_ReportSheetFormatDialog__bOk__Caption = 445;
  svgrid__vgr_ReportSheetFormatDialog__bCancel__Caption = 446;
  svgrid__vgr_BandFormatDialog__cbRowColAutoSize__Caption = 447;
  svgrid__vgr_HeaderFooterOptionsDialog__vgrHeaderFooterOptionsDialogForm__Caption = 450;
  svgrid__vgr_HeaderFooterOptionsDialog__Label1__Caption = 451;
  svgrid__vgr_HeaderFooterOptionsDialog__Label2__Caption = 452;
  svgrid__vgr_HeaderFooterOptionsDialog__Label3__Caption = 453;
  svgrid__vgr_HeaderFooterOptionsDialog__Label4__Caption = 454;
  svgrid__vgr_HeaderFooterOptionsDialog__Label5__Caption = 455;
  svgrid__vgr_HeaderFooterOptionsDialog__bLeftFont__Caption = 456;
  svgrid__vgr_HeaderFooterOptionsDialog__bCenterFont__Caption = 457;
  svgrid__vgr_HeaderFooterOptionsDialog__bRightFont__Caption = 458;
  svgrid__vgr_HeaderFooterOptionsDialog__bPage__Hint = 459;
  svgrid__vgr_HeaderFooterOptionsDialog__bPageCount__Hint = 460;
  svgrid__vgr_HeaderFooterOptionsDialog__bDate__Hint = 461;
  svgrid__vgr_HeaderFooterOptionsDialog__bTime__Hint = 462;
  svgrid__vgr_HeaderFooterOptionsDialog__bTab__Hint = 463;
  svgrid__vgr_HeaderFooterOptionsDialog__bOk__Caption = 464;
  svgrid__vgr_HeaderFooterOptionsDialog__bCancel__Caption = 465;
  svgrid__vgr_PageSetupDialog__Label18__Caption = 466;
  svgrid__vgr_PageSetupDialog__Label19__Caption = 467;
  svgrid__vgr_PageSetupDialog__PHeaderFooter__Caption = 468;
  svgrid__vgr_PageSetupDialog__vgrBevelLabel1__Caption = 469;
  svgrid__vgr_PageSetupDialog__vgrBevelLabel2__Caption = 470;
  svgrid__vgr_PageSetupDialog__bCustomHeader__Caption = 471;
  svgrid__vgr_PageSetupDialog__bCustomFooter__Caption = 472;
  svgrid__vgr_BandFormatDialog__cbCreateSections__Caption = 473;
  svgrid__vgr_WorkbookPreview__Hint__Header = 474;
  svgrid__vgr_WorkbookPreview__Hint__Footer = 475;

implementation

end.
 