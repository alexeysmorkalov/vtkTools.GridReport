{******************************************}
{                                          }
{           vtk GridReport library         }
{                                          }
{      Copyright (c) 2003 by vtkTools      }
{                                          }
{******************************************}

unit vgr_Writers;

interface

{$include vtk.inc}
{$DEFINE VTK_GRIDREPORT}

uses
  {$IFDEF VTK_NOLIC}vgr_ReportAdd, {$ENDIF} 
  Classes, SysUtils, graphics, windows, activex, axctrls,
  {$IFDEF VTK_D6_OR_D7} variants, {$ENDIF}

  
  {$IFNDEF VTK_GRIDREPORT} BIFF8_Types, vteExcelFormula, vteExcel, vteExcelTypes, vteConsts {$ELSE} 
  vgr_BIFF8_Types, vgr_ExcelFormula, vgr_DataStorage, vgr_DataStorageTypes, vgr_CommonClasses, vgr_ExcelTypes, vgr_ExcelConsts {$ENDIF};

const
{$IFDEF VTK_GRIDREPORT}
  sXLSWorksheetTitlePrefix = 'Sheet';
  XLSDefaultRowHeight = $00FF;
  XLSDefaultColumnWidthInChars = $0008;
  MaxDefaultColors = 16;
  MaxBiffRecordSize = 8228;
  mergeBlockItemsCount = 1024; //(MaxBiffRecordSize-4-sizeof(rb8MERGE)) div sizeof(rb8MERGErec);

  sErrorInvalidPictureFormat = 'Invalid picture format';

type

TCardinalArray = array [0..0] of cardinal;
PCardinalArray = ^TCardinalArray;

TvteCustomWriter = class(TObject)
public
  procedure Save(WorkBook : TvgrWorkbook; const FileName : string);  virtual; abstract;
end;
{$ENDIF}

type

/////////////////////////////////////////////////
//
// TvteHtmlCell
//
/////////////////////////////////////////////////
TvteHtmlCell = record
{$IFNDEF VTK_GRIDREPORT}
  Image: TvteImage;
  Range: TvteXLSRange;
{$ELSE}
  Range: IvgrRange;
{$ENDIF}
  StyleId: word;
  Hide : word;
  ImageNum : integer;
  BordersStyleId : word;
end;

THtmlCells = array [0..0] of TvteHtmlCell;

PHtmlCells = ^THtmlCells;


/////////////////////////////////////////////////
//
// TvteHTMLWriter
//
/////////////////////////////////////////////////
TvteHTMLWriter = class(TvteCustomWriter)
private
  FileStream : TFileStream;
  FFileName : string;
  FilesDir : string;
  FName, FileExt : string;
  DirName : string;
  {$IFNDEF VTK_GRIDREPORT}
  FWorkBook : TvteXLSWorkbook;
  {$ELSE}
  FWorkBook : TvgrWorkbook;
  {$ENDIF}
  HtmlCells : PHtmlCells;
  MinPos : integer;
  RowCount, ColCount : integer;
  Styles : TStrings;
  SpansPresent : boolean;

  {$IFNDEF VTK_GRIDREPORT}
  function GetBackgroundColor(Range : TvteXLSRange): string;
  {$ELSE}
  function GetBackgroundColor(Range : IvgrRange): string;
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  function GetBorders(Range : TvteXLSRange): string;
  {$ELSE}
  function GetBorders(Range : IvgrRange): string;
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  procedure CheckBounds(Images : TvteImages);
  procedure AddImage(Image: TvteImage; FileName : string; ImageNum: integer);
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  procedure AddRange(Range: TvteXLSRange);
  {$ELSE}
  procedure AddRange(Range: IvgrRange);
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  procedure SaveBmpToFile(Picture: TPicture; FileName : string);
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  function GenStyle(Range: TvteXLSRange) : string;
  {$ELSE}
  function GenStyle(Range: IvgrRange) : string;
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  function GenCellStyle(Range: TvteXLSRange) : string;
  {$ELSE}
  function GenCellStyle(Range: IvgrRange) : string;
  {$ENDIF}
  procedure SaveHeadFiles;
  procedure SaveMainFile;
  procedure SaveHeadFile;
  procedure WriteStyles;
  {$IFNDEF VTK_GRIDREPORT}
  procedure WriteRowTag(Sheet : TvteXLSWorksheet; RowIndex, Level : integer);
  {$ELSE}
  procedure WriteRowTag(Sheet : TvgrWorksheet; RowIndex, Level : integer);
  {$ENDIF}
  {$IFNDEF VTK_GRIDREPORT}
  procedure WriteCellTag(Sheet : TvteXLSWorksheet; RowIndex,ColumnIndex,Level : integer);
  {$ELSE}
  procedure WriteCellTag(Sheet : TvgrWorksheet; RowIndex,ColumnIndex,Level : integer);
  {$ENDIF}
  function GetSheetFileName(SheetNumber : integer) : string;
  {$IFNDEF VTK_GRIDREPORT}
  function GetCellTagString(Range: TvteXLSRange) : string;
  function GetCellTagStringImg(Image: TvteImage) : string;
  {$ELSE}
  function GetCellTagString(Range: IvgrRange) : string;
  {$ENDIF}
  procedure InitStrings;

  {$IFNDEF VTK_GRIDREPORT}
  function CalcTableWidth(Sheet :TvteXLSWorksheet) : integer;
  function CalcTableHeight(Sheet :TvteXLSWorksheet) : integer;
  function GetTableTag(Sheet: TvteXLSWorksheet): string;
  function GetImgStyle(Image : TvteImage): string;
  {$ELSE}
  function CalcTableWidth(Sheet :TvgrWorksheet) : integer;
  function CalcTableHeight(Sheet :TvgrWorksheet) : integer;
  function GetTableTag(Sheet: TvgrWorksheet): string;
  {$ENDIF}
public
  constructor Create;
  destructor Destroy; override;
  {$IFNDEF VTK_GRIDREPORT}
  procedure SaveSheet(Sheet :TvteXLSWorksheet; FileName : string);
  procedure Save(WorkBook : TvteXLSWorkbook; const FileName : string);  override;
  {$ELSE}
  procedure SaveSheet(Sheet :TvgrWorksheet; FileName : string);
  procedure Save(WorkBook : TvgrWorkbook; const FileName : string);  override;
  {$ENDIF}
end;

/////////////////////////////////////////////////
//
// rXLSRangeRec
//
/////////////////////////////////////////////////
rXLSRangeRec = record
  iXF : integer;
  iSST : integer;
  iFont : integer;
  iFormat : integer;
  Ptgs : PChar;
  PtgsSize : integer;
end;
pXLSRangeRec = ^rXLSRangeRec;
rXLSRangesRec = array [0..0] of rXLSRangeRec;
pXLSRangesRec = ^rXLSRangesRec;

/////////////////////////////////////////////////
//
// rXLSSheetRec
//
/////////////////////////////////////////////////
rXLSSheetRec = record
  StreamBOFOffset : integer;
  StreamBOFOffsetPosition : integer;
end;
rXLSSheetsRecs = array [0..0] of rXLSSheetRec;
pXLSSheetsRecs = ^rXLSSheetsRecs;

/////////////////////////////////////////////////
//
// rXLSImageRec
//
/////////////////////////////////////////////////
rXLSImageRec = record
  BorderLineColorIndex : integer;
  ForegroundFillPatternColorIndex : integer;
  BackgroundFillPatternColorIndex : integer;
end;
pXLSImageRec = ^rXLSImageRec;
rXLSImagesRecs = array [0..0] of rXLSImageRec;
pXLSImagesRecs = ^rXLSImagesRecs;

{$IFDEF VTK_GRIDREPORT}
/////////////////////////////////////////////////
//
// TvteExtSheet
//
/////////////////////////////////////////////////
TvteExtSheet = class(TObject)
private
  FName : string;
  FiSUPBOOK : integer;
  Fitab : integer;
public
  property Name : string read FName;
  property iSUPBOOK : integer read FiSUPBOOK;
  property itab : integer read Fitab;
  constructor Create(_Name : string; _iSUPBOOK : integer; _itab : integer);
end;

/////////////////////////////////////////////////
//
// TvteExtWorkbook
//
/////////////////////////////////////////////////
TvteExtWorkbook = class(TObject)
private
  FName : string;
  FSheets : TList;
  function GetSheet(i : integer) : TvteExtSheet;
  function GetSheetsCount : integer;
public
  property Sheets[i : integer] : TvteExtSheet read GetSheet; default;
  property SheetsCount : integer read GetSheetsCount;
  property Name : string read FName;
  constructor Create(const _Name : string);
  destructor Destroy; override; 
end;

/////////////////////////////////////////////////
//
// TvteExtRefs
//
/////////////////////////////////////////////////
TvteExtRefs = class(TObject)
private
  FBooks: TList;
  FSheets: TList;
  function GetBook(I: integer): TvteExtWorkbook;
  function GetSheet(I: integer): TvteExtSheet;
  function GetBooksCount: integer;
  function GetSheetsCount: integer;
public
  property Books[I: integer]: TvteExtWorkbook read GetBook; default;
  property BooksCount: integer read GetBooksCount;
  property Sheets[I: integer]: TvteExtSheet read GetSheet;
  property SheetsCount: integer read GetSheetsCount;
  function GetSheetIndex(const BookName : string; const SheetName : string) : integer;
  procedure Clear;
  constructor Create;
  destructor Destroy; override;
end;
{$ENDIF}

/////////////////////////////////////////////////
//
// TvteExcelWriter
//
/////////////////////////////////////////////////
TvteExcelWriter = class(TvteCustomWriter, IUnknown, IvteFormulaCompilerOwner)
private
  FBOFOffs : integer;
  {$IFNDEF VTK_GRIDREPORT}
  FWorkBook : TvteXLSWorkbook;
  {$ELSE}
  FWorkBook: TvgrWorkbook;
  FExtRefs: TvteExtRefs;
  {$ENDIF}
  FUsedColors : TList;
  FRangesRecs : pXLSRangesRec;
  FColorPalette : array [0..XLSMaxColorsInPalette-1] of TColor;
  FPaletteModified : boolean;
  FSheetsRecs : pXLSSheetsRecs;
  FImagesRecs : pXLSImagesRecs;
  FCompiler : TvteExcelFormulaCompiler;
  function GetColorPaletteIndex(Color : TColor) : integer;
  procedure BuildFontList(l : TList);
  procedure BuildFormatList(sl : TStringList);
  {$IFNDEF VTK_GRIDREPORT}
  procedure BuildXFRecord(Range : TvteXLSRange; var XF : rb8XF; prr : pXLSRangeRec);
  {$ELSE}
  procedure BuildXFRecord(Range : IvgrRange; var XF : rb8XF; prr : pXLSRangeRec);
  {$ENDIF}
  procedure BuildXFList(l : TList);
  procedure BuildFormulas;
  {$IFNDEF VTK_GRIDREPORT}
  procedure BuildImagesColorsIndexes;
  procedure WriteRangeToStream(Stream : TStream; Range : TvteXLSRange; CurrentRow : integer; var IndexInCellsOffsArray : integer; var CellsOffs : Tb8DBCELLCellsOffsArray);
  procedure WriteSheetToStream(Stream : TStream; Sheet : TvteXLSWorksheet);
  procedure WriteSheetImagesToStream(Stream : TStream; Sheet : TvteXLSWorksheet);
  {$ELSE}
  procedure CompileFormula(const AFormulaString: string; var AFormula: PChar; var AFormulaSize: Integer; AFormulaCol, AFormulaRow: Integer);
  procedure WriteRangeToStream(Stream : TStream; Range : IvgrRange; CurrentRow : integer; var IndexInCellsOffsArray : integer; var CellsOffs : Tb8DBCELLCellsOffsArray);
  procedure WriteSheetToStream(Stream : TStream; Sheet : TvgrWorksheet);
  {$ENDIF}
protected
  // IUnknown
  function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
  function _AddRef: Integer; stdcall;
  function _Release: Integer; stdcall;
  // IvteFormulaCompilerOwner
  function GetStringIndex(const S: string): Integer;
  function GetString(AStringIndex: Integer): string;
  function GetExternalWorkbookIndex(const AWorkbookName: string): Integer;
  function GetExternalSheetIndex(const AWorkbookName, ASheetName: string): Integer;
  function GetExternalSheetName(const AWorkbookName: string; AIndex: Integer): string;
  function GetExternalWorkbookName(AIndex: Integer): string;
  function GetFunctionId(const AFunctionName: string): Integer;
  function GetFunctionName(AId: Integer): string;
public
  constructor Create;
  destructor Destroy; override;
  {$IFNDEF VTK_GRIDREPORT}
  procedure SaveAsBIFFToStream(WorkBook : TvteXLSWorkbook; Stream : TStream);
  procedure Save(WorkBook : TvteXLSWorkbook; const FileName : string); override;
  {$ELSE}
  procedure SaveAsBIFFToStream(WorkBook : TvgrWorkbook; Stream : TStream);
  procedure Save(WorkBook : TvgrWorkbook; const FileName : string); override;
  {$ENDIF}
end;


const
  aDefaultColorPalette : array [0..XLSMaxColorsInPalette-1] of TColor =
                         ($000000,
                          $FFFFFF,
                          $0000FF,
                          $00FF00,
                          $FF0000,
                          $00FFFF,
                          $FF00FF,
                          $FFFF00,
                          $000080,
                          $008000,
                          $800000,
                          $008080,
                          $800080,
                          $808000,
                          $C0C0C0,
                          $808080,
                          $FF9999,
                          $663399,
                          $CCFFFF,
                          $FFFFCC,
                          $660066,
                          $8080FF,
                          $CC6600,
                          $FFCCCC,
                          $800000,
                          $FF00FF,
                          $00FFFF,
                          $FFFF00,
                          $800080,
                          $000080,
                          $808000,
                          $FF0000,
                          $FFCC00,
                          $FFFFCC,
                          $CCFFCC,
                          $99FFFF,
                          $FFCC99,
                          $CC99FF,
                          $FF99CC,
                          $99CCFF,
                          $FF6633,
                          $CCCC33,
                          $00CC99,
                          $00CCFF,
                          $0099FF,
                          $0066FF,
                          $996666,
                          $969696,
                          $663300,
                          $669933,
                          $003300,
                          $003333,
                          $003399,
                          $663399,
                          $993333,
                          $333333);
  aDefaultColors : array [0..MaxDefaultColors-1] of integer =
                   (clWhite,clBlack,clSilver,clGray,
                    clRed,clMaroon,clYellow,clOlive,
                    clLime,clGreen,clAqua,clTeal,
                    clBlue,clNavy,clFuchsia,clPurple);

  aHtmlCellBorders : array[vtexlEdgeBottom..vtexlEdgeTop] of string = ('bottom','left','right','top');

  {$IFNDEF VTK_GRIDREPORT}
  aBorderLineStyles : array[vtelsNone..vtelsSlantedDashDot] of string =
    ('none','.5pt solid','1.0pt solid',
     '.5pt dashed','.5pt dotted','1.5pt solid',
     '2.0pt double','.5pt hairline','1.0pt dashed',
     '.5pt dot-dash','1.0pt dot-dash','.5pt dot-dot-dash',
     '1.0pt dot-dot-dash','1.0pt dot-dash-slanted');
  {$ELSE}
  aBorderLineStyles : array[0..5] of string =
    ('none','solid','dashed','dotted','dot-dash','dot-dot-dash');
  {$ENDIF}

  aBorderImageLineStyles : array [vteblsSolid..vteblsLightGray] of string =
    ('.5pt solid','.5pt dashed','.5pt dotted',
     '.5pt dot-dash','.5pt dot-dot-dash','none',
     '.5pt solid DarkGray','.5pt solid MediumGray','.5 pt solid LightGray');

implementation

uses
  {$IFDEF VTK_GRIDREPORT}vgr_ExcelFormula_iftab, vgr_FormulaCalculator, vgr_Consts, {$ENDIF} Math, vgr_PageProperties;

{$IFDEF VTK_GRIDREPORT}
type
  TvgrWorksheetAccess = class(TvgrWorksheet)
  end;

  TvgrWorkbookAccess = class(TvgrWorkbook)
  end;
  
function BrushStyleToXLSFillPattern(Value: TBrushStyle): TvteXLSFillPattern;
const
  cBrushStyleToXLSFillPatternTeable : array[TBrushStyle] of TvteXLSFillPattern =
  (vtefpSolid, vtefpNone, vtefpHorizontal, vtefpVertical,
   vtefpLightDown, vtefpLightUp, vtefpGrid, vtefpCrissCross);
begin
  Result := cBrushStyleToXLSFillPatternTeable[Value];
end;

function GetRangeBorder(ARange: IvgrRange; AvteBorder: TvteXLSBorderType): IvgrBorder;
begin
  case AvteBorder of
    vtexlEdgeTop: Result := ARange.Worksheet.BordersList.Find(ARange.Left, ARange.Top, vgrboTop);
    vtexlEdgeBottom: Result := ARange.Worksheet.BordersList.Find(ARange.Left, ARange.Top+1, vgrboTop);
    vtexlEdgeLeft: Result := ARange.Worksheet.BordersList.Find(ARange.Left, ARange.Top, vgrboLeft);
    vtexlEdgeRight: Result := ARange.Worksheet.BordersList.Find(ARange.Left, ARange.Top+1, vgrboLeft);
  else
    Result := nil;
  end;
end;

function TwipsToPoints(Value: Integer):Integer;
begin
  Result := MulDiv(Value, 72, TwipsPerInch);
end;

function TwipsToPixels(Value: Integer):Integer;
begin
  Result := MulDiv(Value, 96, TwipsPerInch);
end;

function PointsToPixels(Value: Integer): Single;
begin
  Result := MulDiv(Value,96,72);
end;
{$ENDIF}
// MakeHTMLString
// Replaces special symbols according to the specification HTML
function MakeHTMLString(Value : string): string;
var
  i : integer;
begin
  Result := '';
  for i := 1 to Length(Value) do
    case Value[i] of
      '"' : Result := Result + vteHtml_quot;
      '<' : Result := Result + vteHtml_lt;
      '>' : Result := Result + vteHtml_gt;
      '&' : Result := Result + vteHtml_amp;
      ' ' : if (i = 1) or (Value[i-1] = ' ') then
              Result := Result + vteHtml_space
            else
              Result := Result + Value[i];
      #13 : Result := Result + vteHtml_crlf;
      #10 : if (i = 1) or (Value[i-1] <> #13) then
              Result := Result + vteHtml_crlf;
    else
      Result := Result + Value[i];
    end;
end;

// WriteBlockSeparator
// Writes down CRLF in the specified stream
procedure WriteBlockSeparator( AStream : TStream);
var
  P : PChar;
begin
  P := @vteBLOCKSEPARATOR[1];
  AStream.Write(P^,Length(vteBLOCKSEPARATOR));
end;

// WriteStringToStream
// Writes Value string in the specified stream
procedure WriteStringToStream(AStream: TStream; Value : string);
var
  P : PChar;
begin
  P := @Value[1];
  AStream.Write(P^,Length(Value));
end;

// WriteLevelMargin
// Writes down Level spaces in specified stream
procedure WriteLevelMargin( AStream : TStream; Level : integer);
begin
  AStream.Write(vteMAXMARGINSTRING,Min(Length(vteMAXMARGINSTRING),Level));
end;

// WriteStringWithFormatToStream
// Writes Value string in the specified stream with margin and line feed
procedure WriteStringWithFormatToStream( AStream : TStream; Value : string; Level : integer );
begin
  WriteLevelMargin(AStream, Level);
  WriteStringToStream(AStream, Value);
  WriteBlockSeparator(AStream);
end;

// WriteOpenTagFormat
procedure WriteOpenTagFormat( AStream : TStream; Tag : string; Level : integer );
begin
  WriteStringWithFormatToStream(AStream, Format('%s%s%s',[vteOPENTAGPREFIX,tag,vteTAGPOSTFIX]),Level);
end;

// WriteOpenTagClassFormat
// writes Tag to AStream with specified ClassId
procedure WriteOpenTagClassFormat( AStream : TStream; Tag : string; Level : integer ; ClassId : integer);
var
  ClName : string;
begin
  ClName := Format(vteSTYLEFORMAT,[ClassId]);
  WriteStringWithFormatToStream(AStream, Format('%s%s class=%s %s',[vteOPENTAGPREFIX,tag,ClName,vteTAGPOSTFIX]),Level);
end;

// WriteCloseTagFormat
procedure WriteCloseTagFormat( AStream : TStream; Tag : string; Level : integer );
begin
  WriteStringWithFormatToStream(AStream, Format('%s%s%s',[vteCLOSETAGPREFIX,tag,vteTAGPOSTFIX]),Level);
end;

///////////////////////////
//
// TvtkeHTMLWriter
//
///////////////////////////
constructor TvteHTMLWriter.Create;
begin
  inherited;
  Styles := TStringList.Create;
  Styles.Add(vteTABLESTYLE);
end;

destructor TvteHTMLWriter.Destroy;
begin
  Styles.Free;
  inherited;
end;

procedure TvteHTMLWriter.SaveHeadFiles;
var
  Code : integer;
begin
  Code := GetFileAttributes(PChar(FilesDir));
  if (Code=-1) or (FILE_ATTRIBUTE_DIRECTORY and Code = 0) then
    CreateDir(FilesDir);
  SaveMainFile;
  SaveHeadFile;
end;

procedure TvteHTMLWriter.SaveMainFile;
begin
    WriteStringWithFormatToStream(FileStream,vteHTML_VERSION,0);
    WriteOpenTagFormat(FileStream,vteHTMLTAG,0);
    WriteOpenTagFormat(FileStream,vteHEADTAG,0);
    WriteOpenTagFormat(FileStream,vteTITLETAG,1);
    WriteStringWithFormatToStream(FileStream,MakeHTMLString(FName),2);
    WriteCloseTagFormat(FileStream,vteTITLETAG,1);
    WriteCloseTagFormat(FileStream,vteHEADTAG,0);
    WriteStringWithFormatToStream(FileStream,'<FRAMESET rows="39,*" border=0 width=0 frameborder=no framespacing=0>',1);
    WriteStringWithFormatToStream(FileStream,Format('<FRAME name="header" src="%s/header.htm" marginwidth=0 marginheight=0>',[DirName]),2);
    WriteStringWithFormatToStream(FileStream,Format('<FRAME name="sheet" src="%s/Sheet0.htm">',[DirName]),2);
    WriteStringWithFormatToStream(FileStream,'</FRAMESET>',1);

    WriteCloseTagFormat(FileStream,vteHTMLTAG,0);
end;

procedure TvteHTMLWriter.SaveHeadFile;
var
  fs : TFileStream;
  i : integer;
begin
  fs := TFileStream.Create(FilesDir+'\header.htm',fmCreate or fmShareDenyWrite);
  try
    WriteStringWithFormatToStream(fs,vteHTML_VERSION,0);
    WriteOpenTagFormat(fs,vteHTMLTAG,0);
    WriteOpenTagFormat(fs,vteHEADTAG,0);
    WriteOpenTagFormat(fs,vteTITLETAG,1);
    WriteStringWithFormatToStream(fs,MakeHTMLString(FName),2);
    WriteCloseTagFormat(fs,vteTITLETAG,1);
    WriteOpenTagFormat(fs,vteSTYLETAG,0);
    WriteStringWithFormatToStream(fs,'<!--'#13#10'A { text-decoration:none; color:#000000; font-size:9pt; } A:Active { color : #0000E0}'#13#10'-->',1);
    WriteCloseTagFormat(fs,vteSTYLETAG,0);
    WriteCloseTagFormat(fs,vteHEADTAG,0);
    WriteStringWithFormatToStream(fs,'<body topmargin=0 leftmargin=0 bgcolor="#808080">',0);
    WriteStringWithFormatToStream(fs,'<table border=0 cellspacing=1 height=100%>',0);
    WriteStringWithFormatToStream(fs,'<tr height=10><TD>',1);
    WriteStringWithFormatToStream(fs,'<tr>',1);
    {$IFNDEF VTK_GRIDREPORT}
    for i := 0 to FWorkBook.SheetsCount-1 do
    {$ELSE}
    for i := 0 to FWorkBook.WorksheetsCount-1 do
    {$ENDIF}
    begin
      WriteStringToStream(fs,Format('<td bgcolor="#FFFFFF" nowrap><b><small><small>&nbsp;<A href="Sheet%d.htm" target=sheet><font face="Arial">%s</FONT></A>&nbsp;</small></small></b></td>',
      {$IFNDEF VTK_GRIDREPORT}
        [i,TvteXLSWorksheet(FWorkBook.Sheets[i]).Title]));
      {$ELSE}
        [i,FWorkBook.Worksheets[i].Title]));
      {$ENDIF}
    end;
    WriteCloseTagFormat(fs,vteROWTAG,0);
    WriteCloseTagFormat(fs,vteTABLETAG,0);
    WriteCloseTagFormat(fs,vteBODYTAG,0);
    WriteCloseTagFormat(fs,vteHTMLTAG,0);
  finally
    fs.Free;
  end;
end;

procedure TvteHTMLWriter.WriteStyles;
var
  i : integer;
begin
  WriteOpenTagFormat(FileStream,vteSTYLETAG,2);
  for i := 0 to Styles.Count-1 do
    WriteStringToStream(FileStream,Format('.'+vteSTYLEFORMAT+' { %s } '#13#10,[i,Styles[i]]));
  WriteCloseTagFormat(FileStream,vteSTYLETAG,2);
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.WriteRowTag(Sheet : TvteXLSWorksheet; RowIndex,Level : integer);
{$ELSE}
procedure TvteHTMLWriter.WriteRowTag(Sheet : TvgrWorksheet; RowIndex,Level : integer);
{$ENDIF}
var
  {$IFNDEF VTK_GRIDREPORT}
  Row : TvteXLSRow;
  {$ELSE}
  Row : IvgrRow;
  {$ENDIF}
  RowHeight : integer;
begin
  if RowIndex >= 0 then
  begin
    {$IFNDEF VTK_GRIDREPORT}
    Row := Sheet.FindRow(RowIndex);
    {$ELSE}
    Row := Sheet.RowByIndex[RowIndex];
    {$ENDIF}
    if Row = nil  then
    {$IFNDEF VTK_GRIDREPORT}
      RowHeight := Sheet.GetDefaultRowPixelHeight
    {$ELSE}
      RowHeight := Trunc(PointsToPixels(XLSDefaultRowHeight)/20)
    {$ENDIF}
    else
    {$IFNDEF VTK_GRIDREPORT}
      RowHeight := Row.PixelHeight;
    {$ELSE}
      RowHeight := TwipsToPixels(Row.Height);
    {$ENDIF}
  end
  else
    RowHeight := 0;
  WriteStringWithFormatToStream(FileStream,Format('%s%s style="%s:%dpx" %s',[vteOPENTAGPREFIX,vteROWTAG,vteHEIGHTATTRIBUTE,RowHeight,vteTAGPOSTFIX]),Level);
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.WriteCellTag(Sheet : TvteXLSWorksheet; RowIndex,ColumnIndex,Level : integer);
{$ELSE}
procedure TvteHTMLWriter.WriteCellTag(Sheet : TvgrWorksheet; RowIndex,ColumnIndex,Level : integer);
{$ENDIF}
var
  S : string;
  {$IFNDEF VTK_GRIDREPORT}
  Col : TvteXLSCol;
  {$ELSE}
  Col : IvgrCol;
  {$ENDIF}
  ColWidth : integer;
begin
  S := vteOPENTAGPREFIX+vteCELLTAG;
  if (RowIndex = MinPos) then
  begin
    if (ColumnIndex >= 0) then
    begin
      {$IFNDEF VTK_GRIDREPORT}
      Col := Sheet.FindCol(ColumnIndex);
      {$ELSE}
      Col := Sheet.ColsList.Find(ColumnIndex);
      {$ENDIF}
      if Col <> nil then
        {$IFNDEF VTK_GRIDREPORT}
        ColWidth := Col.PixelWidth
        {$ELSE}
        ColWidth := TwipsToPixels(Col.Width)
        {$ENDIF}
      else
        {$IFNDEF VTK_GRIDREPORT}
        ColWidth := Sheet.GetDefaultColumnPixelWidth;
        {$ELSE}
        ColWidth := XLSDefaultColumnWidthInChars*8;
        {$ENDIF}
    end
    else
      ColWidth := 0;
    S := S + Format(' style="%s:%dpx"',[vteWIDTHATTRIBUTE,ColWidth]);
  end;
  if (RowIndex >= 0) and (ColumnIndex >= 0) then
  begin
    {$IFNDEF VTK_GRIDREPORT}
    if (HtmlCells^[RowIndex*ColCount+ColumnIndex].Image <> nil) then
    begin
      S := S + GetCellTagStringImg(HtmlCells^[RowIndex*ColCount+ColumnIndex].Image);
      S := S + ' CLASS='+Format(vteSTYLEFORMAT,[HtmlCells^[RowIndex*ColCount+ColumnIndex].BordersStyleId]);
    end
    else
    {$ENDIF}
    if (HtmlCells^[RowIndex*ColCount+ColumnIndex].Range <> nil) then
    begin
      S := S + GetCellTagString(HtmlCells^[RowIndex*ColCount+ColumnIndex].Range);
      S := S + ' CLASS='+Format(vteSTYLEFORMAT,[HtmlCells^[RowIndex*ColCount+ColumnIndex].BordersStyleId]);
    end ;
  end;
  S := S + vteTAGPOSTFIX;
  WriteStringWithFormatToStream(FileStream,S,Level);
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.AddImage(Image: TvteImage; FileName: string; ImageNum: integer);
var
  i,j : integer;
  ABottom, ARight : integer;
begin
  with Image do
  begin
    if Image.ScalePercentX > 0 then
      ARight := Left+1
    else
      ARight := Right;
    if Image.ScalePercentY > 0 then
      ABottom := Top+1
    else
      ABottom := Bottom;
    for i := Top to ABottom-1 do
      for j := Left to ARight-1 do
      begin
        if (i = Top) and (j = Left) then
        begin
          HtmlCells^[i*ColCount+j].Image := Image;
          HtmlCells^[i*ColCount+j].ImageNum := ImageNum;
        end
        else
        begin
          SpansPresent := True;
          HtmlCells^[i*ColCount+j].Hide := 1;
        end;
      end;
    SaveBmpToFile(Picture,FileName);
  end;
end;
{$ENDIF}

{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.AddRange(Range: TvteXLSRange);
{$ELSE}
procedure TvteHTMLWriter.AddRange(Range: IvgrRange);
{$ENDIF}
var
  i,j : integer;
  StStr : string;
  BstIndex, StIndex : integer;
begin
  with Range do
  begin
    StStr := GenStyle(Range);
    StIndex := Styles.IndexOf(StStr);
    if StIndex < 0 then
    begin
      Styles.Add(StStr);
      StIndex := Styles.Count-1;
    end;
    StStr := GenCellStyle(Range);
    BStIndex := Styles.IndexOf(StStr);
    if BStIndex < 0 then
    begin
      Styles.Add(StStr);
      BStIndex := Styles.Count-1;
    end;
    for i := Place.Top to Place.Bottom do
      for j := Place.Left to Place.Right do
      begin
        if (i = Place.Top) and (j = Place.Left) then
        begin
          HtmlCells^[i*ColCount+j].Range := Range;
          HtmlCells^[i*ColCount+j].StyleId := StIndex;
          HtmlCells^[i*ColCount+j].BordersStyleId := BStIndex;
        end
        else
        begin
          SpansPresent := True;
          HtmlCells^[i*ColCount+j].Hide := 1;
        end;
      end;
  end;
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.SaveBmpToFile(Picture: TPicture; FileName : string);
var
  bm : TPicture;
begin
  if (CompareText(Picture.Graphic.ClassName,'TBitmap')=0) then
    Picture.SaveToFile(FileName)
  else
  begin
    bm := TPicture.Create;
    try
      bm.Bitmap.Width := Picture.Width;
      bm.Bitmap.Height := Picture.Height;
      bm.Bitmap.Canvas.Draw(0,0,Picture.Graphic);
      bm.SaveToFile(FileName);
    finally
      bm.Free;
    end;
  end;
end;
{$ENDIF}

{$IFNDEF VTK_GRIDREPORT}
function Getfont_family(Font: TFont) : string;
{$ELSE}
function Getfont_family(Font: IvgrRangeFont) : string;
{$ENDIF}
begin
  Result := Font.Name
end;


{$IFNDEF VTK_GRIDREPORT}
function Getfont_size(Font: TFont) : word;
{$ELSE}
function Getfont_size(Font: IvgrRangeFont) : word;
{$ENDIF}
begin
  Result := Font.Size
end;

{$IFNDEF VTK_GRIDREPORT}
function Getfont_weight(Font: TFont) : string;
{$ELSE}
function Getfont_weight(Font: IvgrRangeFont) : string;
{$ENDIF}
begin
  if fsBold in Font.Style then
    Result := vteFONT_BOLD
  else
    Result := vteFONT_NORMAL;
end;

{$IFNDEF VTK_GRIDREPORT}
function Getfont_style(Font: TFont) : string;
{$ELSE}
function Getfont_style(Font: IvgrRangeFont) : string;
{$ENDIF}
begin
  if fsItalic in Font.Style then
    Result := vteFONT_ITALIC
  else
    Result := vteFONT_NORMAL;
end;

{$IFNDEF VTK_GRIDREPORT}
function GetText_decoration(Font: TFont) : string;
{$ELSE}
function GetText_decoration(Font: IvgrRangeFont) : string;
{$ENDIF}
begin
  Result := '';
  if fsUnderline in Font.Style then
    Result := vteFONT_UNDERLINE;
  if fsStrikeout in Font.Style then
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + vteFONT_STRIKE;
  end;
  if Result = '' then
    Result := vteFONT_NONE;
end;

function GetColor(Color : TColor): string;
var
  r,g,b : PByte;
  AColor: Longint;
begin
  AColor := ColorToRGB(Color);
  r := @AColor;
  g := @AColor;
  Inc(g,1);
  b := @AColor;
  Inc(b,2);
  Result := Format('#%.2x%.2x%.2x', [r^,g^,b^]);
end;

{$IFNDEF VTK_GRIDREPORT}
function GetVAlign(Align : TvteXLSVerticalAlignmentType) : string;
{$ELSE}
function GetVAlign(Align : TvgrRangeVertAlign) : string;
{$ENDIF}
var
  Val : string;
begin
  {$IFNDEF VTK_GRIDREPORT}
  if Align = vtexlVAlignJustify then
    Result := ''
  else
  {$ENDIF}
  begin
    Result := vteVALIGN+':';
    case Align of
      {$IFNDEF VTK_GRIDREPORT}
      vtexlVAlignTop : Val := vteTEXTTOP;
      {$ELSE}
      vgrvaTop : Val := vteTEXTTOP;
      {$ENDIF}
      {$IFNDEF VTK_GRIDREPORT}
      vtexlVAlignCenter : Val := vteMiddle;
      {$ELSE}
      vgrvaCenter : Val := vteMiddle;
      {$ENDIF}
      {$IFNDEF VTK_GRIDREPORT}
      vtexlVAlignBottom : Val := vteTEXTBOTTOM;
      {$ELSE}
      vgrvaBottom : Val := vteTEXTBOTTOM;
      {$ENDIF}
    end;
    Result := Result+Val+';';
  end;
end;

{$IFNDEF VTK_GRIDREPORT}
function GetTextAlign(Align : TvteXLSHorizontalAlignmentType) : string;
{$ELSE}
function GetTextAlign(Align : TvgrRangeHorzAlign) : string;
{$ENDIF}
var
  Val : string;
begin
  {$IFNDEF VTK_GRIDREPORT}
  if not (Align in [vtexlHAlignLeft,vtexlHAlignCenter,vtexlHAlignRight,vtexlHAlignJustify]) then
    Result := ''
  else
  {$ENDIF}
  begin
    Result := vteTEXTALIGN+':';
    case Align of
      {$IFNDEF VTK_GRIDREPORT}
      vtexlHAlignLeft: Val := vteLEFT;
      {$ELSE}
      vgrhaLeft: Val := vteLEFT;
      {$ENDIF}
      {$IFNDEF VTK_GRIDREPORT}
      vtexlHAlignCenter: Val := vteCENTER;
      {$ELSE}
      vgrhaCenter: Val := vteCENTER;
      {$ENDIF}
      {$IFNDEF VTK_GRIDREPORT}
      vtexlHAlignRight:  Val := vteRIGHT;
      vtexlHAlignJustify: Val := vteJustify;
      {$ELSE}
      vgrhaRight: Val := vteRIGHT;
      {$ENDIF}
    end;
    Result := Result+Val+';';
  end;
end;

// Returns the background color of style string by the Range
{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GetBackgroundColor(Range : TvteXLSRange): string;
{$ELSE}
function TvteHTMLWriter.GetBackgroundColor(Range : IvgrRange): string;
{$ENDIF}
begin
  {$IFNDEF VTK_GRIDREPORT}
  if Range.FillPattern = vtefpNone then
  {$ELSE}
  if Range.FillPattern = bsClear then
  {$ENDIF}
    Result := ''
  else
    {$IFNDEF VTK_GRIDREPORT}
    Result := vteBackgroundColor+':'+GetColor(Range.ForegroundFillPatternColor)+';';
    {$ELSE}
    Result := vteBackgroundColor+':'+GetColor(Range.FillBackColor)+';';
    {$ENDIF}
end;

{$IFNDEF VTK_GRIDREPORT}
function GetBorderId(Border : TvteXLSBorderType) : string;
begin
  if (Border >= vtexlEdgeBottom) and (Border <= vtexlEdgeTop) then
    Result := aHtmlCellBorders[Border]
  else
    Result := '';
end;
{$ENDIF}

// Returns the border line style part of style string by the Range
{$IFNDEF VTK_GRIDREPORT}
function GetLineStyle(BorderLineStyle : TvteXLSLineStyleType): string;
begin
  Result := aBorderLineStyles[BorderLineStyle];
end;
{$ELSE}
function GetLineStyle(BorderLineStyle : Integer): string;
begin
  Result := aBorderLineStyles[BorderLineStyle];
end;
{$ENDIF}

// Returns the borders part of style string by the Range
{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GetBorders(Range : TvteXLSRange): string;
{$ELSE}
function TvteHTMLWriter.GetBorders(Range : IvgrRange): string;
{$ENDIF}
var
  {$IFNDEF VTK_GRIDREPORT}
  Eq : boolean;
  i : integer;
  lt : TvteXLSLineStyleType;
  lc : TColor;
  {$ELSE}
  ABorderLeft: IvgrBorder;
  ABorderRight: IvgrBorder;
  ABorderTop: IvgrBorder;
  ABorderBottom: IvgrBorder;
  ALeft, ATop: Integer;
  {$ENDIF}
begin
  Result := '';
  {$IFNDEF VTK_GRIDREPORT}
  Eq := True;
  for i:=integer(vtexlEdgeBottom) to integer(High(TvteXLSBorderType)) do
  begin
    if (i > integer(vtexlEdgeBottom)) and(
       (Range.Borders[TvteXLSBorderType(i-1)].LineStyle <> Range.Borders[TvteXLSBorderType(i)].LineStyle) or
       (Range.Borders[TvteXLSBorderType(i-1)].Color <> Range.Borders[TvteXLSBorderType(i)].Color)) then
      Eq := false;
    lt := Range.Borders[TvteXLSBorderType(i)].LineStyle;
    lc := Range.Borders[TvteXLSBorderType(i)].Color;
    if lt <> vtelsNone then
      Result := Result+'border-'+GetBorderId(TvteXLSBorderType(i))+': '+GetLineStyle(lt)+' '+GetColor(lc)+';';
  end;
  if Eq then
      Result := 'border:'+GetLineStyle(lt)+' '+GetColor(lc)+';';
  {$ELSE}
  ALeft := Range.Left;
  ATop := Range.Top;
  Result := '';
  ABorderLeft := Range.Worksheet.BordersList.Find(ALeft,ATop,vgrboLeft);
  if ABorderLeft <> nil then
    Result := 'border-left:'+Format(' %dpx ',[TwipsToPixels(ABorderLeft.Width)])+GetLineStyle(Ord(ABorderLeft.Pattern)+1)+' '+GetColor(ABorderLeft.Color)+';';
  ABorderRight := Range.Worksheet.BordersList.Find(ALeft+1,ATop,vgrboLeft);
  if ABorderRight <> nil then
    Result := Result + 'border-right:'+Format(' %dpx ',[TwipsToPixels(ABorderRight.Width)])+GetLineStyle(Ord(ABorderRight.Pattern)+1)+' '+GetColor(ABorderRight.Color)+';';
  ABorderTop := Range.Worksheet.BordersList.Find(ALeft,ATop,vgrboTop);
  if ABorderTop <> nil then
    Result := Result +  'border-top:'+Format(' %dpx ',[TwipsToPixels(ABorderTop.Width)])+GetLineStyle(Ord(ABorderTop.Pattern)+1)+' '+GetColor(ABorderTop.Color)+';';
  ABorderBottom := Range.Worksheet.BordersList.Find(ALeft,ATop+1,vgrboTop);
  if ABorderBottom <> nil then
    Result := Result +  'border-bottom:'+Format(' %dpx ',[TwipsToPixels(ABorderBottom.Width)])+GetLineStyle(Ord(ABorderBottom.Pattern)+1)+' '+GetColor(ABorderBottom.Color)+';';
  {$ENDIF}
end;

// TvteHTMLWriter.GenStyle
// Returns Style string for given Range
{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GenStyle(Range: TvteXLSRange) : string;
{$ELSE}
function TvteHTMLWriter.GenStyle(Range: IvgrRange) : string;
{$ENDIF}
begin

  Result := Format('font-family : ''%s''; font-size : %dpt; font-weight : %s; font-style : %s;  text-decoration : %s ; color : %s',
    [Getfont_family(Range.Font),
     Getfont_size(Range.Font),
     Getfont_weight(Range.Font),
     Getfont_style(Range.Font),
     Gettext_decoration(Range.Font),
     GetColor(Range.Font.Color)]);
end;

{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GenCellStyle(Range: TvteXLSRange) : string;
{$ELSE}
function TvteHTMLWriter.GenCellStyle(Range: IvgrRange) : string;
{$ENDIF}
begin
  Result := Format('%s %s %s %s',
    [GetBorders(Range),
     GetBackgroundColor(Range),
     {$IFNDEF VTK_GRIDREPORT}
     GetVAlign(Range.VerticalAlignment),
     GetTextAlign(Range.HorizontalAlignment)]);
     {$ELSE}
     GetVAlign(Range.VertAlign),
     GetTextAlign(Range.HorzAlign)]);
     {$ENDIF}
end;

// TvteHTMLWriter.GetSheetFileName
// Returns FileName for Sheet by page number of Sheet
function TvteHTMLWriter.GetSheetFileName(SheetNumber : integer) : string;
begin
  Result := Format('%s\Sheet%d%s',[FilesDir,SheetNumber,'.htm']);
end;

procedure TvteHTMLWriter.InitStrings;
begin
  FileExt := ExtractFileExt(FFileName);
  FName := Copy(FFileName,1,Length(FFileName)-Length(FileExt));
  FilesDir := FName+'_files';
  DirName := ExtractFileName(FilesDir);
end;

{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.CalcTableWidth(Sheet : TvteXLSWorksheet) : integer;
{$ELSE}
function TvteHTMLWriter.CalcTableWidth(Sheet : TvgrWorksheet) : integer;
{$ENDIF}
var
  {$IFNDEF VTK_GRIDREPORT}
  Col : TvteXLSCol;
  {$ELSE}
  Col : IvgrCol;
  {$ENDIF}
  i, ColWidth : integer;
begin
  Result := 0;
  for i := 0 to ColCount-1 do
  begin
    {$IFNDEF VTK_GRIDREPORT}
    Col := Sheet.FindCol(i);
    {$ELSE}
    Col := Sheet.ColsList.Find(i);
    {$ENDIF}
    if Col <> nil then
      {$IFNDEF VTK_GRIDREPORT}
      ColWidth := Col.PixelWidth
      {$ELSE}
      ColWidth := TwipsToPixels(Col.Width)
      {$ENDIF}
    else
      {$IFNDEF VTK_GRIDREPORT}
      ColWidth := Sheet.GetDefaultColumnPixelWidth;
      {$ELSE}
      ColWidth := XLSDefaultColumnWidthInChars*8;
      {$ENDIF}
    Inc(Result,ColWidth);
  end;
end;

{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.CalcTableHeight(Sheet : TvteXLSWorksheet) : integer;
{$ELSE}
function TvteHTMLWriter.CalcTableHeight(Sheet : TvgrWorksheet) : integer;
{$ENDIF}
var
  {$IFNDEF VTK_GRIDREPORT}
  Row : TvteXLSRow;
  {$ELSE}
  Row : IvgrRow;
  {$ENDIF}
  i, RowHeight : integer;
begin
  Result := 0;
  for i := 0 to RowCount-1 do
  begin
    {$IFNDEF VTK_GRIDREPORT}
    Row := Sheet.FindRow(i);
    {$ELSE}
    Row := Sheet.RowsList.Find(i);
    {$ENDIF}
    if Row <> nil then
      {$IFNDEF VTK_GRIDREPORT}
      RowHeight := Row.PixelHeight
      {$ELSE}
      RowHeight := TwipsToPixels(Row.Height)
      {$ENDIF}
    else
      {$IFNDEF VTK_GRIDREPORT}
      RowHeight := Sheet.GetDefaultRowPixelHeight;
      {$ELSE}
      RowHeight := Trunc(PointsToPixels(XLSDefaultRowHeight)/20);
      {$ENDIF}
    Inc(Result,RowHeight);
  end;
end;

{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GetTableTag(Sheet: TvteXLSWorksheet): string;
{$ELSE}
function TvteHTMLWriter.GetTableTag(Sheet: TvgrWorksheet): string;
{$ENDIF}
begin
  Result := Format(vteTABLETAG+' style="width:%dpx;height:%dpx"',
                  [CalcTableWidth(Sheet),CalcTableHeight(Sheet)])
end;

{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GetImgStyle(Image : TvteImage): string;
var
  Wstr,Hstr : string;
begin
  if (Image.ScalePercentX = 0) then
    WStr := '100%'
  else
    WStr := IntToStr(MulDiv(Image.Picture.Graphic.Width,Image.ScalePercentX,100))+'px';
  if (Image.ScalePercentY = 0) then
    HStr := '100%'
  else
    HStr := IntToStr(MulDiv(Image.Picture.Graphic.Height,Image.ScalePercentY,100))+'px';
  Result := Format('width:%s;heigth:%s;border: %s %s',[WStr,HStr,GetColor(Image.BorderLineColor),aBorderImageLineStyles[Image.BorderLineStyle]]);
end;
{$ENDIF}

// TvteHTMLWriter.Save
// Save Workbook with HTML format
{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.Save(WorkBook : TvteXLSWorkbook; const FileName : string);
{$ELSE}
procedure TvteHTMLWriter.Save(WorkBook : TvgrWorkbook; const FileName : string);
{$ENDIF}
var
  i : integer;
  Writer : TvteHTMLWriter;
begin
  FFileName := FileName;
  InitStrings;
  FileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
  try

    FWorkBook := WorkBook;
    SaveHeadFiles;
    {$IFNDEF VTK_GRIDREPORT}
    for i := 0 to WorkBook.SheetsCount - 1 do
    {$ELSE}
    for i := 0 to WorkBook.WorksheetsCount - 1 do
    {$ENDIF}
    begin
      Writer := TvteHTMLWriter.Create;
      try
        {$IFNDEF VTK_GRIDREPORT}
        Writer.SaveSheet(TvteXLSWorksheet(WorkBook.Sheets[i]),GetSheetFileName(i));
        {$ELSE}
        Writer.SaveSheet(WorkBook.Worksheets[i],GetSheetFileName(i));
        {$ENDIF}
      finally
        Writer.Free;
      end;
    end;
  finally
    FileStream.Free;
  end;
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.CheckBounds(Images : TvteImages);
var
  i : integer;
begin
  for i := 0 to Images.Count - 1 do
  begin
    RowCount := Max(RowCount,Images[i].Bottom);
    ColCount := Max(ColCount,Images[i].Right);
  end;
end;
{$ENDIF}

// TvteHTMLWriter.SaveSheet
// Saves Sheet with HTML format
{$IFNDEF VTK_GRIDREPORT}
procedure TvteHTMLWriter.SaveSheet(Sheet :TvteXLSWorksheet; FileName : string);
{$ELSE}
procedure TvteHTMLWriter.SaveSheet(Sheet :TvgrWorksheet; FileName : string);
{$ENDIF}
var
  i,j : integer;
  ImgFileName : string;
  S: string;
begin
  ImgFileName := ChangeFileExt(FileName, '');
  FileStream := TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
  try
    with Sheet do
    begin
        SpansPresent := false;
        RowCount := Dimensions.Bottom+1;
        ColCount := Dimensions.Right+1;
        {$IFNDEF VTK_GRIDREPORT}
        CheckBounds(Images);
        {$ENDIF}
        HtmlCells := AllocMem(RowCount*ColCount*SizeOf(TvteHtmlCell));
        try
          {$IFNDEF VTK_GRIDREPORT}
          for i := 0 to Images.Count - 1 do
            Self.AddImage(Images[i], Format('%s_p%d.bmp',[ImgFileName,i]),i);
          {$ENDIF}
          for i := 0 to RangesCount - 1 do
            Self.AddRange(RangeByIndex[i]);

          if SpansPresent then
            MinPos := -1
          else
            MinPos := 0;
          WriteStringWithFormatToStream(FileStream,vteHTML_VERSION,0);
          WriteOpenTagFormat(FileStream,vteHTMLTAG,0);
          WriteOpenTagFormat(FileStream,vteHEADTAG,0);
          WriteOpenTagFormat(FileStream,vteTITLETAG,1);
          WriteStringWithFormatToStream(FileStream,MakeHTMLString(Sheet.Title),2);
          WriteCloseTagFormat(FileStream,vteTITLETAG,1);
          WriteStyles;
          WriteCloseTagFormat(FileStream,vteHEADTAG,0);
          WriteOpenTagFormat(FileStream,vteBODYTAG,0);
          WriteOpenTagFormat(FileStream,vteFORMTAG,0);
          WriteOpenTagClassFormat(FileStream,GetTableTag(Sheet) ,0,0);
          for i := MinPos to RowCount-1 do
          begin
            WriteRowTag(Sheet,i,1);
            for j := MinPos to ColCount-1 do
            begin
              if ((i < 0) or (j < 0)) or (HtmlCells^[i*ColCount+j].Hide = 0) then
              begin
                WriteCellTag(Sheet,i,j,2);
                if (i >= 0) and (j >= 0) then
                begin
                  {$IFNDEF VTK_GRIDREPORT}
                  if (HtmlCells^[i*ColCount+j].Image <> nil) then
                    WriteStringWithFormatToStream(FileStream,'<IMG src="'+Format('%s_p%d.bmp',[ExtractFileName(ImgFileName),HtmlCells^[i*ColCount+j].ImageNum])+Format('" style="%S"',[GetImgStyle(HtmlCells^[i*ColCount+j].Image)])+'>',2)
                  else
                  {$ENDIF}
                  if (HtmlCells^[i*ColCount+j].Range <> nil) then
                  begin
                    S := HtmlCells^[i*ColCount+j].Range.DisplayText;
                    {
                    if V = Null then
                      S := ''
                    else
                      S := V;
                    }
                    WriteStringWithFormatToStream(FileStream,'<SPAN CLASS='+Format(vteSTYLEFORMAT,[HtmlCells^[i*ColCount+j].StyleId])+'>'+MakeHTMLString(S)+'</SPAN>',2);
                  end;
                end;
                WriteCloseTagFormat(FileStream,vteCELLTAG,1);
              end;
            end;
            WriteCloseTagFormat(FileStream,vteROWTAG,1);
          end;
          WriteCloseTagFormat(FileStream,vteTABLETAG,1);
          WriteCloseTagFormat(FileStream,vteFORMTAG,0);
          WriteCloseTagFormat(FileStream,vteBODYTAG,0);
          WriteCloseTagFormat(FileStream,vteHTMLTAG,0);
        finally
          FreeMem(HtmlCells);
        end;
      end;
  finally
    FileStream.Free;
  end;
end;

// TvteHTMLWriter.GetCellTagString
// Returns a line with rowspan, colspan attributes for formation tag
// TD according to Range.Place
{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GetCellTagString(Range: TvteXLSRange) : string;
{$ELSE}
function TvteHTMLWriter.GetCellTagString(Range: IvgrRange) : string;
{$ENDIF}
var
  ColSpan, RowSpan : integer;
begin
  Result := '';
  with Range do
  begin
    RowSpan := Place.Bottom - Place.Top + 1;
    ColSpan := Place.Right - Place.Left + 1;
  end;
  if RowSpan > 1 then
    Result := Result + Format(' %s=%d',[vteROWSPANATTRIBUTE,rowspan]);
  if ColSpan > 1 then
    Result := Result + Format(' %s=%d',[vteCOLSPANATTRIBUTE,colspan]);
end;

{$IFNDEF VTK_GRIDREPORT}
function TvteHTMLWriter.GetCellTagStringImg(Image: TvteImage) : string;
var
  ColSpan, RowSpan : integer;
begin
  Result := '';
  with Image do
  begin
    RowSpan := Bottom - Top;
    ColSpan := Right - Left;
  end;
  if RowSpan > 1 then
    Result := Result + Format(' %s=%d',[vteROWSPANATTRIBUTE,rowspan]);
  if ColSpan > 1 then
    Result := Result + Format(' %s=%d',[vteCOLSPANATTRIBUTE,colspan]);
end;
{$ENDIF}

procedure wbiff(Stream : TStream; code : word; buf : pointer; size : integer);
var
  sz : word;
begin
repeat
  Stream.Write(code,2);
  sz := Min(size,MaxBiffRecordSize-4);
  Stream.Write(sz,2);
  if sz>0 then
    begin
      Stream.Write(buf^,sz);
      buf := PChar(buf)+sz;
      size := size-sz;
      code := b8_CONTINUE;
    end
until size=0;
end;

procedure wbiffFont(Stream : TStream; f : TFont; ColorPaletteIndex : word);
var
  font : pb8FONT;
  lf : TLogFont;
  lfont : integer;
begin
lfont := Length(f.Name)*sizeof(WideChar);
font := AllocMem(sizeof(rb8FONT)+lfont);
try
  GetObject(f.Handle, SizeOf(TLogFont), @lf);
  StringToWideChar(f.Name,PWideChar(PChar(font)+sizeof(rb8FONT)),lfont);
  font.dyHeight := f.Size*20;
  if fsItalic in f.Style then
    font.grbit := font.grbit or b8_FONT_grbit_fItalic;
  if fsStrikeout in f.Style then
    font.grbit := font.grbit or b8_FONT_grbit_fStrikeout;
  font.icv := ColorPaletteIndex;
  if fsBold in f.Style then
    font.bls := $3E8  // from MSDN
  else
    font.bls := $64;  // from MSDN
  if fsUnderline in f.Style then
    font.uls := 1;  // from MSDN
  font.bFamily := lf.lfPitchAndFamily;
  font.bCharSet := lf.lfCharSet;
  font.cch := Length(f.Name);
  font.cchgrbit := $01;

  wbiff(Stream,b8_FONT,font,sizeof(rb8FONT)+lfont);
finally
  FreeMem(font);
end;
end;

procedure wbiffFormat(Stream : TStream; const FormatString : string; FormatCode : word);
var
  lformat : integer;
  format : pb8FORMAT;
begin
lformat := Length(FormatString)*sizeof(WideChar);
format := AllocMem(sizeof(rb8FORMAT)+lformat);
try
  StringToWideChar(FormatString,PWideChar(PChar(format)+sizeof(rb8FORMAT)),lformat);
  format.ifmt := FormatCode;
  format.cch := Length(FormatString);
  format.cchgrbit := $01;
  wbiff(Stream,b8_FORMAT,format,sizeof(rb8FORMAT)+lformat);
finally
  FreeMem(format);
end;
end;

function HexStringToString(const s : string) : string;
var
  b1 : string;
  i,ls : integer;
begin
Result := '';
ls := length(s);
i := 1;
while i<=ls do
  begin
    while (i<=ls) and not(s[i] in ['0'..'9','a'..'f','A'..'F']) do Inc(i);
    if i>ls then break;
    b1 := '';
    while (i<=ls) and (s[i] in ['0'..'9','a'..'f','A'..'F']) do
      begin
        b1 := b1+s[i];
        Inc(i);
      end;
    if b1<>'' then
      Result := Result+char(StrToInt('$'+b1));
    if (b1='') or (i>ls) then break;
  end;
end;

procedure wbiffHexString(Stream : TStream; const HexString : string);
var
  s : string;
begin
s := HexStringToString(HexString);
Stream.Write(s[1],Length(s));
end;

{$IFDEF VTK_GRIDREPORT}
/////////////////////////////////////////////////
//
// TvteExtSheet
//
/////////////////////////////////////////////////
constructor TvteExtSheet.Create(_Name : string; _iSUPBOOK : integer; _itab : integer);
begin
inherited Create;
FName := _Name;
FiSUPBOOK := _iSUPBOOK;
Fitab := _itab;
end;

/////////////////////////////////////////////////
//
// TvteExtWorkbook
//
/////////////////////////////////////////////////
constructor TvteExtWorkbook.Create(const _Name : string);
begin
inherited Create;
FName := _Name;
FSheets := TList.Create;
end;

destructor TvteExtWorkbook.Destroy;
begin
FSheets.Free;
inherited;
end;

function TvteExtWorkbook.GetSheet(i : integer) : TvteExtSheet;
begin
Result := TvteExtSheet(FSheets[i]);
end;

function TvteExtWorkbook.GetSheetsCount : integer;
begin
Result := FSheets.Count;
end;

/////////////////////////////////////////////////
//
// TvteExtRefs
//
/////////////////////////////////////////////////
constructor TvteExtRefs.Create;
begin
inherited;
FBooks := TList.Create;
FSheets := TList.Create;
end;

destructor TvteExtRefs.Destroy;
begin
Clear;
FSheets.Free;
FBooks.Free;
inherited;
end;

function TvteExtRefs.GetBook(i : integer) : TvteExtWorkbook;
begin
Result := TvteExtWorkbook(FBooks[i]);
end;

function TvteExtRefs.GetSheet(i : integer) : TvteExtSheet;
begin
Result := TvteExtSheet(FSheets[i]);
end;

function TvteExtRefs.GetBooksCount : integer;
begin
Result := FBooks.Count;
end;

function TvteExtRefs.GetSheetsCount : integer;
begin
Result := FSheets.Count;
end;

procedure TvteExtRefs.Clear;
var
  i : integer;
begin
for i:=0 to FBooks.Count-1 do
  TvteExtWorkbook(FBooks[i]).Free;
for i:=0 to FSheets.Count-1 do
  TvteExtSheet(FSheets[i]).Free;
FBooks.Clear;
FSheets.Clear;
end;

function TvteExtRefs.GetSheetIndex(const BookName : string; const SheetName : string) : integer;
var
  i,iBook : integer;
  Book : TvteExtWorkbook;
  Sheet : TvteExtSheet;
begin
iBook := 0;
while (iBook<FBooks.Count) and (Books[iBook].Name<>BookName) do Inc(iBook);
if iBook>=FBooks.Count then
  begin
    Book := TvteExtWorkbook.Create(BookName);
    iBook := FBooks.Add(Book);
    Sheet := TvteExtSheet.Create(SheetName,iBook,0);
    Book.FSheets.Add(Sheet);
    Result := FSheets.Add(Sheet);
  end
else
  begin
    Book := Books[iBook];
    i := 0;
    while (i<Book.SheetsCount) and (Book.Sheets[i].Name<>SheetName) do Inc(i);
    if i<Book.SheetsCount then
      Result := FSheets.IndexOf(Book.Sheets[i])
    else
      begin
        Sheet := TvteExtSheet.Create(SheetName,iBook,Book.SheetsCount);
        Book.FSheets.Add(Sheet);
        Result := FSheets.Add(Sheet);
      end;
  end;
end;
{$ENDIF}

/////////////////////////////////////////////////
//
// TvteExcelWriter
//
/////////////////////////////////////////////////
constructor TvteExcelWriter.Create;
begin
  inherited;
{$IFDEF VTK_GRIDREPORT}
  FExtRefs := TvteExtRefs.Create;
{$ENDIF}
  FCompiler := TvteExcelFormulaCompiler.Create(Self);
  FUsedColors := TList.Create;
end;

destructor TvteExcelWriter.Destroy;
begin
  FCompiler.Free;
  FUsedColors.Free;
{$IFDEF VTK_GRIDREPORT}
  FExtRefs.Free;
{$ENDIF}
  inherited;
end;

function TvteExcelWriter.GetStringIndex(const S: string): Integer;
begin
  Result := IvteFormulaCompilerOwner(TvgrWorkbookAccess(FWorkBook).Formulas).GetStringIndex(S);
end;

function TvteExcelWriter.GetString(AStringIndex: Integer): string;
begin
  Result := IvteFormulaCompilerOwner(TvgrWorkbookAccess(FWorkbook).Formulas).GetString(AStringIndex);
end;

function TvteExcelWriter.GetExternalWorkbookIndex(const AWorkbookName: string): Integer;
begin
  Result := IvteFormulaCompilerOwner(TvgrWorkbookAccess(FWorkBook).Formulas).GetExternalWorkbookIndex(AWorkbookName);
end;

function TvteExcelWriter.GetExternalWorkbookName(AIndex: Integer): string;
begin
  Result := IvteFormulaCompilerOwner(TvgrWorkbookAccess(FWorkBook).Formulas).GetExternalWorkbookName(AIndex);
end;

function TvteExcelWriter.GetExternalSheetIndex(const AWorkbookName, ASheetName: string): Integer;
begin
  Result := FExtRefs.GetSheetIndex(AWorkbookName, ASheetName);
//  Result := IvteFormulaCompilerOwner(FWorkBook.Formulas).GetExternalSheetIndex(AWorkbookName, ASheetName);
end;

function TvteExcelWriter.GetExternalSheetName(const AWorkbookName: string; AIndex: Integer): string;
begin
  Result := ''; // not called while export
//  Result := IvteFormulaCompilerOwner(FWorkBook.Formulas).GetExternalSheetName(AWorkbookName, AIndex);
end;

function TvteExcelWriter.GetFunctionId(const AFunctionName: string): Integer;
begin
  Result := 1;
  while (Result <= vteExcelFunctionsCount) and (AnsiCompareText(vteExcelFunctions[Result].FuncName, AFunctionName) <> 0) do Inc(Result);
  if Result <= vteExcelFunctionsCount then
    Result := vteExcelFunctions[Result].iftab
  else
    Result := -1;
end;

function TvteExcelWriter.GetFunctionName(AId: Integer): string;
var
  I: Integer;
begin
  I := 1;
  while (I <= vteExcelFunctionsCount) and (vteExcelFunctions[I].iftab <> AId) do Inc(I);
  if I <= vteExcelFunctionsCount then
    Result := vteExcelFunctions[I].FuncName
  else
    Result := '';
end;

function TvteExcelWriter.QueryInterface(const IID: TGUID; out Obj): HResult;
begin
  if GetInterface(IID, Obj) then
    Result := S_OK
  else
    Result := E_NOINTERFACE
end;

function TvteExcelWriter._AddRef: Integer;
begin
  Result := S_OK
end;

function TvteExcelWriter._Release: Integer;
begin
  Result := S_OK
end;

procedure TvteExcelWriter.BuildFontList(l : TList);
var
  {$IFNDEF VTK_GRIDREPORT}
  f : TFont;
  sh : TvteXLSWorksheet;
  ran : TvteXLSRange;
  {$ELSE}
  f : IvgrRangeFont;
  sh : TvgrWorksheet;
  ran : IvgrRange;
  {$ENDIF}
  i,j,k,n : integer;
begin
n := 0;
{$IFNDEF VTK_GRIDREPORT}
for i:=0 to FWorkBook.SheetsCount-1 do
{$ELSE}
for i:=0 to FWorkBook.WorkSheetsCount-1 do
{$ENDIF}
  begin
    {$IFNDEF VTK_GRIDREPORT}
    sh := FWorkBook.Sheets[i];
    {$ELSE}
    sh := FWorkBook.WorkSheets[i];
    {$ENDIF}
    for j:=0 to sh.RangesCount-1 do
      begin
        ran := sh.RangeByIndex[j];
        ran.ExportData := @FRangesRecs[n];
        f := ran.Font;
        k := 0;
        while (k<L.Count) and
              ((TFont(L[k]).Charset<>f.Charset) or
               (TFont(L[k]).Color<>f.Color) or
               {$IFNDEF VTK_GRIDREPORT}
               (TFont(L[k]).Height<>f.Height) or
               {$ENDIF}
               (TFont(L[k]).Name<>f.Name) or
               (TFont(L[k]).Pitch<>f.Pitch) or
               (TFont(L[k]).Size<>f.Size) or
               (TFont(L[k]).Style<>f.Style)) do Inc(k);
        if k>=L.Count then
          begin
            k := L.Add(TFont.Create);
            {$IFNDEF VTK_GRIDREPORT}
            TFont(L[k]).Assign(f);
            {$ELSE}
            f.AssignTo(TFont(L[k]));
            {$ENDIF}
          end;
        FRangesRecs[n].iFont := k+1;
        Inc(n);
      end;
  end;
end;

procedure TvteExcelWriter.BuildFormatList(sl : TStringList);
var
  {$IFNDEF VTK_GRIDREPORT}
  sh : TvteXLSWorksheet;
  ran : TvteXLSRange;
  {$ELSE}
  sh : TvgrWorksheet;
  ran : IvgrRange;
  {$ENDIF}
  i,j,k,n,m : integer;
begin
n := sl.Count;
m := 0;
{$IFNDEF VTK_GRIDREPORT}
for i:=0 to FWorkBook.SheetsCount-1 do
{$ELSE}
for i:=0 to FWorkBook.WorkSheetsCount-1 do
{$ENDIF}
  begin
    {$IFNDEF VTK_GRIDREPORT}
    sh := FWorkBook.Sheets[i];
    {$ELSE}
    sh := FWorkBook.WorkSheets[i];
    {$ENDIF}
    for j:=0 to sh.RangesCount-1 do
      begin
        ran := sh.RangeByIndex[j];
        {$IFNDEF VTK_GRIDREPORT}
        if ran.Format='' then
        {$ELSE}
        if ran.DisplayFormat='' then
        {$ENDIF}
          FRangesRecs[m].iFormat := 0
        else
          begin
            {$IFNDEF VTK_GRIDREPORT}
            k := sl.IndexOf(ran.Format);
            {$ELSE}
            k := sl.IndexOf(ran.DisplayFormat);
            {$ENDIF}
            if k=-1 then
              {$IFNDEF VTK_GRIDREPORT}
              k := sl.AddObject(ran.Format,pointer(sl.Count-n+$32));
              {$ELSE}
              k := sl.AddObject(ran.DisplayFormat,pointer(sl.Count-n+$32));
              {$ENDIF}
            FRangesRecs[m].iFormat := integer(sl.Objects[k]);
          end;
        Inc(m);
      end;
  end;
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.BuildXFRecord(Range : TvteXLSRange; var XF : rb8XF; prr : pXLSRangeRec);
{$ELSE}
procedure TvteExcelWriter.BuildXFRecord(Range : IvgrRange; var XF : rb8XF; prr : pXLSRangeRec);
{$ENDIF}
const
  aFillPattern : array [TvteXLSFillPattern] of integer = (0,-4105,9,16,-4121,18,17,-4124,-4125,-4126,15,-4128,13,11,14,12,10,1,-4162,-4166);
  aHorizontalAlignment : array [TvteXLSHorizontalAlignmentType] of integer =
                         (b8_XF_Opt2_alcGeneral,
                          b8_XF_Opt2_alcLeft,
                          b8_XF_Opt2_alcCenter,
                          b8_XF_Opt2_alcRight,
                          b8_XF_Opt2_alcFill,
                          b8_XF_Opt2_alcJustify,
                          b8_XF_Opt2_alcCenterAcrossSelection);
  aVerticalAlignment : array [TvteXLSVerticalAlignmentType] of integer =
                         (b8_XF_Opt2_alcVTop,
                          b8_XF_Opt2_alcVCenter,
                          b8_XF_Opt2_alcVBottom,
                          b8_XF_Opt2_alcVJustify);
  aWrapText : array [boolean] of integer = (0,b8_XF_Opt2_fWrap);
  {$IFNDEF VTK_GRIDREPORT}
  aBorderLineStyle : array [TvteXLSLineStyleType] of word =
                     (b8_XF_Border_None,
                      b8_XF_Border_Thin,
                      b8_XF_Border_Medium,
                      b8_XF_Border_Dashed,
                      b8_XF_Border_Dotted,
                      b8_XF_Border_Thick,
                      b8_XF_Border_Double,
                      b8_XF_Border_Hair,
                      b8_XF_Border_MediumDashed,
                      b8_XF_Border_DashDot,
                      b8_XF_Border_MediumDashDot,
                      b8_XF_Border_DashDotDot,
                      b8_XF_Border_MediumDashDotDot,
                      b8_XF_Border_SlantedDashDot);
  {$ELSE}
  aBorderLineStyleVgr : array [TvgrBorderStyle] of word =
                     (b8_XF_Border_Thin,
                      b8_XF_Border_Dashed,
                      b8_XF_Border_Dotted,
                      b8_XF_Border_DashDot,
                      b8_XF_Border_DashDotDot);
  {$ENDIF}
  function GetBorderColorIndex(b : TvteXLSBorderType) : integer;
  {$IFDEF VTK_GRIDREPORT}
  var
    ABorder: IvgrBorder;
    ALeft, ATop: Integer;
  {$ENDIF}
  begin
  {$IFDEF VTK_GRIDREPORT}
  ALeft := Range.Left;
  ATop := Range.Top;
  case b of
    vtexlEdgeTop: ABorder := Range.Worksheet.BordersList.Find(ALeft, ATop, vgrboTop);
    vtexlEdgeBottom: ABorder := Range.Worksheet.BordersList.Find(ALeft, ATop+1, vgrboTop);
    vtexlEdgeLeft: ABorder := Range.Worksheet.BordersList.Find(ALeft, ATop, vgrboLeft);
    vtexlEdgeRight: ABorder := Range.Worksheet.BordersList.Find(ALeft, ATop+1, vgrboLeft);
  else
    ABorder := nil;
  end;
  if ABorder = nil then
    Result := 0
  else
    Result := GetColorPaletteIndex(ABorder.Color); // ??? + 8 - dont know
  end;
  {$ELSE}
  if Range.Borders[b].LineStyle=vtelsNone then
    Result := 0
  else
    Result := GetColorPaletteIndex(Range.Borders[b].Color); // ??? + 8 - dont know
  end;
  {$ENDIF}
var
  {$IFNDEF VTK_GRIDREPORT}
  DiagBorderLineStyle : TvteXLSLineStyleType;
  DiagBorderColorIndex : integer;
  {$ELSE}
  ABorder: IvgrBorder;
  {$ENDIF}
begin
ZeroMemory(@XF,sizeof(XF));
XF.ifnt := prr.iFont;
XF.ifmt := pXLSRangeRec(Range.ExportData).iFormat;
XF.Opt1 := $0001;//b8_XF_Opt1_fLocked or b8_XF_Opt1_fHidden;
{$IFNDEF VTK_GRIDREPORT}
XF.Opt2 := aHorizontalAlignment[Range.HorizontalAlignment] or
           aWrapText[Range.WrapText] or
           aVerticalAlignment[Range.VerticalAlignment];
{$ELSE}
XF.Opt2 := aHorizontalAlignment[TvteXLSHorizontalAlignmentType(Range.HorzAlign)] or
           aWrapText[Range.WordWrap] or
           aVerticalAlignment[TvteXLSVerticalAlignmentType(Range.VertAlign)];
{$ENDIF}
{$IFNDEF VTK_GRIDREPORT}
XF.trot := Range.Rotation;
{$ELSE}
XF.trot := Range.Angle;
{$ENDIF}
XF.Opt3 := b8_XF_Opt3_fAtrNum or
           b8_XF_Opt3_fAtrFnt or
           b8_XF_Opt3_fAtrAlc or
           b8_XF_Opt3_fAtrBdr or
           b8_XF_Opt3_fAtrPat;
if (Range.Place.Left<>Range.Place.Right) or (Range.Place.Top<>Range.Place.Bottom) then
  XF.Opt3 := XF.Opt3 or b8_XF_Opt3_fMergeCell;

// borders
{$IFNDEF VTK_GRIDREPORT}
XF.Borders1 := (aBorderLineStyle[Range.Borders[vtexlEdgeLeft].LineStyle]) or
               (aBorderLineStyle[Range.Borders[vtexlEdgeRight].LineStyle] shl 4) or
               (aBorderLineStyle[Range.Borders[vtexlEdgeTop].LineStyle] shl 8) or
               (aBorderLineStyle[Range.Borders[vtexlEdgeBottom].LineStyle] shl 12);
DiagBorderLineStyle := vtelsNone;
DiagBorderColorIndex := 0;
XF.Borders2 := 0;
if Range.Borders[vtexlDiagonalDown].LineStyle<>vtelsNone then
  begin
    XF.Borders2 := XF.Borders2 or $4000;
    DiagBorderLineStyle := Range.Borders[vtexlDiagonalDown].LineStyle;
    DiagBorderColorIndex := GetColorPaletteIndex(Range.Borders[vtexlDiagonalDown].Color)+8;
  end;
if Range.Borders[vtexlDiagonalUp].LineStyle<>vtelsNone then
  begin
    XF.Borders2 := XF.Borders2 or $8000;
    DiagBorderLineStyle := Range.Borders[vtexlDiagonalUp].LineStyle;
    DiagBorderColorIndex := GetColorPaletteIndex(Range.Borders[vtexlDiagonalUp].Color)+8;
  end;
XF.Borders2 := XF.Borders2 or
               (GetBorderColorIndex(vtexlEdgeLeft)) or
               (GetBorderColorIndex(vtexlEdgeRight) shl 7);
XF.Borders3 := (GetBorderColorIndex(vtexlEdgeTop)) or
               (GetBorderColorIndex(vtexlEdgeBottom) shl 7) or
               (DiagBorderColorIndex shl 14) or
               (aBorderLineStyle[DiagBorderLineStyle] shl 21) or
               (aFillPattern[Range.FillPattern] shl 26);
{$ELSE}
XF.Borders1 := 0;
ABorder := GetRangeBorder(Range,vtexlEdgeLeft);
if ABorder <> nil then
  XF.Borders1 := aBorderLineStyleVgr[ABorder.Pattern];
ABorder := GetRangeBorder(Range,vtexlEdgeRight);
if ABorder <> nil then
  XF.Borders1 := XF.Borders1 or (aBorderLineStyleVgr[ABorder.Pattern]  shl 4);
ABorder := GetRangeBorder(Range,vtexlEdgeTop);
if ABorder <> nil then
  XF.Borders1 := XF.Borders1 or (aBorderLineStyleVgr[ABorder.Pattern]  shl 8);
ABorder := GetRangeBorder(Range,vtexlEdgeBottom);
if ABorder <> nil then
  XF.Borders1 := XF.Borders1 or (aBorderLineStyleVgr[ABorder.Pattern]  shl 12);
XF.Borders2 := 0;
XF.Borders2 := (GetBorderColorIndex(vtexlEdgeLeft)) or
               (GetBorderColorIndex(vtexlEdgeRight) shl 7);
XF.Borders3 := (GetBorderColorIndex(vtexlEdgeTop)) or
               (GetBorderColorIndex(vtexlEdgeBottom) shl 7) or
               (aFillPattern[BrushStyleToXLSFillPattern(Range.FillPattern)] shl 26);
{$ENDIF}
{$IFNDEF VTK_GRIDREPORT}
if Range.FillPattern<>vtefpNone then
XF.Colors := (GetColorPaletteIndex(Range.ForegroundFillPatternColor)) or
             (GetColorPaletteIndex(Range.BackgroundFillPatternColor) shl 7) // colors for fill pattern
else
XF.Colors := (GetColorPaletteIndex(Range.ForegroundFillPatternColor)) or
             (GetColorPaletteIndex(Range.BackgroundFillPatternColor) shl 7) // colors for fill pattern
{$ELSE}
if Range.FillPattern<>bsClear  then
XF.Colors := (GetColorPaletteIndex(Range.FillBackColor)) or
             (GetColorPaletteIndex(Range.FillForeColor) shl 7) // colors for fill pattern
else
XF.Colors := (GetColorPaletteIndex(Range.FillBackColor)) or
             (GetColorPaletteIndex(Range.FillForeColor) shl 7) // colors for fill pattern
{$ENDIF}
end;

procedure TvteExcelWriter.BuildXFList(l : TList);
var
  p : pointer;
  XF : rb8XF;
  {$IFNDEF VTK_GRIDREPORT}
  sh : TvteXLSWorksheet;
  ran : TvteXLSRange;
  {$ELSE}
  sh : TvgrWorksheet;
  ran : IvgrRange;
  {$ENDIF}
  i,j,k,n : integer;
begin
n := 0;
{$IFNDEF VTK_GRIDREPORT}
for i:=0 to FWorkBook.SheetsCount-1 do
{$ELSE}
for i:=0 to FWorkBook.WorkSheetsCount-1 do
{$ENDIF}
  begin
    {$IFNDEF VTK_GRIDREPORT}
    sh := FWorkBook.Sheets[i];
    {$ELSE}
    sh := FWorkBook.WorkSheets[i];
    {$ENDIF}
    for j:=0 to sh.RangesCount-1 do
      begin
        ran := sh.RangeByIndex[j];
        BuildXFRecord(ran,XF,@FRangesRecs[n]);
        k := 0;
        while (k<l.Count) and not CompareMem(l[k],@XF,sizeof(rb8XF)) do Inc(k);
        if k>=l.Count then
          begin
            GetMem(p,sizeof(rb8XF));
            CopyMemory(p,@XF,sizeof(rb8XF));
            k := l.Add(p);
          end;
        FRangesRecs[n].iXF := k+15; // 15 - count of STYLE XF records
        Inc(n);
      end;
  end;
end;

procedure TvteExcelWriter.BuildFormulas;
var
  {$IFNDEF VTK_GRIDREPORT}
  sh : TvteXLSWorksheet;
  ran : TvteXLSRange;
  {$ELSE}
  sh : TvgrWorksheet;
  ran : IvgrRange;
  {$ENDIF}
  i,j,n : integer;
begin
n := 0;
{$IFNDEF VTK_GRIDREPORT}
for i:=0 to FWorkBook.SheetsCount-1 do
{$ELSE}
for i:=0 to FWorkBook.WorkSheetsCount-1 do
{$ENDIF}
  begin
    {$IFNDEF VTK_GRIDREPORT}
    sh := FWorkBook.Sheets[i];
    {$ELSE}
    sh := FWorkBook.WorkSheets[i];
    {$ENDIF}
    for j:=0 to sh.RangesCount-1 do
      begin
        {$IFNDEF VTK_GRIDREPORT}
        ran := sh.RangeByIndex[j];
        {$ELSE}
        ran := sh.RangesList.ByIndex[j];
        {$ENDIF}
        FRangesRecs[n].Ptgs := nil;
        FRangesRecs[n].PtgsSize := 0;
        {$IFNDEF VTK_GRIDREPORT}
        if ran.CellDataType = vtecdtFormula then
          FCompiler.CompileFormula(ran.Formula,
                                   pvteFormula(FRangesRecs[n].Ptgs),
                                   FRangesRecs[n].PtgsSize,
                                   ran.Place.Left,
                                   ran.Place.Top);
        {$ELSE}
        if ran.Formula <> '' then
          CompileFormula(ran.Formula,
                         FRangesRecs[n].Ptgs,
                         FRangesRecs[n].PtgsSize,
                         ran.Place.Left,
                         ran.Place.Top);
        {$ENDIF}
        Inc(n);
      end;
  end;
end;

function TvteExcelWriter.GetColorPaletteIndex(Color : TColor) : integer;

  function DefaultColorIndex(c : TColor) : integer;
  begin
  Result := 0;
  while (Result<MaxDefaultColors) and (aDefaultColors[Result]<>c) do Inc(Result);
  if Result>=MaxDefaultColors then
    Result := -1;
  end;
  
begin
if (Color and $80000000)<>0 then
  Color := GetSysColor(Color and $00FFFFFF);
if FUsedColors.IndexOf(pointer(Color))=-1 then
  FUsedColors.Add(pointer(Color));
Result := 0;
while (Result<XLSMaxColorsInPalette) and (FColorPalette[Result]<>Color) do Inc(Result);
if Result<XLSMaxColorsInPalette then
  begin
    Result := Result+8;
    exit; // color exist in current palette
  end;
Result := 0;
while Result<XLSMaxColorsInPalette do
  begin
    if (DefaultColorIndex(FColorPalette[Result])=-1) and
       (FUsedColors.IndexOf(pointer(FColorPalette[Result]))=-1) then
      begin
        // replace color in palette with new color
        FColorPalette[Result] := Color;
        FPaletteModified := true;
        Result := Result+8;
        exit;
      end;
    Inc(Result);
  end;
Result := 8;
//Result := 1; // return index to BLACK color
end;

{$IFDEF DEBUG}
procedure WriteToLog(Msg : string);
var
  hFile : THandle;

  procedure WriteString(s : string);
  var
    BytesWritten : cardinal;
  begin
  s := s+#13#10;
  WriteFile(hFile,(@s[1])^,Length(s),BytesWritten,nil);
  end;

begin
hFile:=CreateFile('c:\vtkexport.txt',
                  GENERIC_WRITE,
                  FILE_SHARE_WRITE or FILE_SHARE_READ,
                  nil,
                  OPEN_ALWAYS,
                  FILE_ATTRIBUTE_NORMAL or FILE_FLAG_WRITE_THROUGH,
                  0);
if (hFile=INVALID_HANDLE_VALUE) then
  exit;

SetFilePointer(hFile,0,nil,FILE_END);

WriteString(Msg);

FlushFileBuffers(hFile);
CloseHandle(hFile);
end;
{$ENDIF}

{$IFNDEF VTK_GRIDREPORT}
function sort(Item1, Item2: Pointer): Integer;
begin
Result := TvteXLSRange(Item1).Place.Left-TvteXLSRange(Item2).Place.Left;
end;
{$ENDIF}

{$IFDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.CompileFormula(const AFormulaString: string;
                                         var AFormula: PChar;
                                         var AFormulaSize: Integer;
                                         AFormulaCol, AFormulaRow: Integer);
var
  I: Integer;
  S: string;
  ATempFormula: pvteFormula;
  ATempFormulaSize: Integer;
  AFormulaItem: pvteFormulaItem;

  AFuncPtg: rptgFuncVar;
  ARefPtg: rptgRef;
  ARef3DPtg: rptgRef3D;
  AAreaPtg: rptgArea;
  AArea3DPtg: rptgArea3D;
  AIntPtg: rptgInt;
  ANumPtg: rptgNum;
  AStrPtg: pptgStr;
  AStrPtgSize: Integer;

  procedure Addptg(APtgCode: Byte; APtgData: Pointer; APtgDataSize: integer);
  begin
    ReallocMem(AFormula, AFormulaSize + APtgDataSize + 1);
    AFormula[AFormulaSize] := char(APtgCode);
    if APtgData <> nil then
      MoveMemory(AFormula + 1 + AFormulaSize, APtgData, APtgDataSize);
    AFormulaSize := AFormulaSize + APtgDataSize + 1;
  end;

  procedure CopyCellInfo(var ARw, ACl: Word;
                         ARow, ACol, AFlags: Integer;
                         AColAbsoluteFlag, ARowAbsoluteFlag: Integer);
  begin
    ARw := AFormulaRow + ARow;
    ACl := AFormulaCol + ACol;
    if (AColAbsoluteFlag and AFlags) = 0 then
      ACl := ACl or $8000;
    if (ARowAbsoluteFlag and AFlags) = 0 then
      ACl := ACl or $4000;
  end;

begin
  if FCompiler.CompileFormula(AFormulaString, ATempFormula, ATempFormulaSize, AFormulaCol, AFormulaRow) then
  begin
    // convert formula to Excel format
    if ATempFormulaSize > 0 then
    begin
      try
        for I := 0 to ATempFormulaSize - 1 do
        begin
          AFormulaItem := @ATempFormula^[I];
          case AFormulaItem.ItemType of
            vteitOperator: Addptg(AFormulaItem.Operator.Id, nil, 0);
            vteitFunc:
              begin
                AFuncPtg.cargs := AFormulaItem.Func.ParamCount;
                AFuncPtg.iftab := AFormulaItem.Func.Id; //GetFunctionId(RegisteredFunctions[AFormulaItem.Func.Id].Name);
                Addptg(ptgFuncVar, @AFuncPtg, sizeof(rptgFuncVar));
              end;
            vteitCellRef:
              begin
                if AFormulaItem.CellRef.Sheet = -1 then
                begin
                  // no sheet
                  CopyCellInfo(ARefPtg.rw, ARefPtg.grbitCol,
                               AFormulaItem.CellRef.Row,
                               AFormulaItem.CellRef.Col,
                               AFormulaItem.CellRef.Flags,
                               rvteCellRefColAbsolute,
                               rvteCellRefRowAbsolute);
                  Addptg(ptgRef, @ARefPtg, sizeof(rptgRef));
                end
                else
                begin
                  // with sheet
                  ARef3DPtg.ixti := AFormulaItem.CellRef.Sheet;
                  CopyCellInfo(ARef3DPtg.rw, ARef3DPtg.grbitCol,
                               AFormulaItem.CellRef.Row,
                               AFormulaItem.CellRef.Col,
                               AFormulaItem.CellRef.Flags,
                               rvteCellRefColAbsolute,
                               rvteCellRefRowAbsolute);
                  Addptg(ptgRef3D, @ARef3DPtg, sizeof(rptgRef3D));
                end;
              end;
            vteitRangeRef:
              begin
                if AFormulaItem.RangeRef.Sheet = -1 then
                begin
                  // no sheet
                  CopyCellInfo(AAreaPtg.rwFirst, AAreaPtg.grbitColFirst,
                               AFormulaItem.RangeRef.TopRow,
                               AFormulaItem.RangeRef.LeftCol,
                               AFormulaItem.RangeRef.Flags,
                               rvteRangeRefLeftColAbsolute,
                               rvteRangeRefTopRowAbsolute);

                  CopyCellInfo(AAreaPtg.rwLast, AAreaPtg.grbitColLast,
                               AFormulaItem.RangeRef.BottomRow,
                               AFormulaItem.RangeRef.RightCol,
                               AFormulaItem.RangeRef.Flags,
                               rvteRangeRefRightColAbsolute,
                               rvteRangeRefBottomRowAbsolute);

                  Addptg(ptgArea, @AAreaPtg, sizeof(rptgArea));
                end
                else
                begin
                  // with sheet
                  AArea3DPtg.ixti := AFormulaItem.CellRef.Sheet;

                  CopyCellInfo(AArea3DPtg.rwFirst, AArea3DPtg.grbitColFirst,
                               AFormulaItem.RangeRef.TopRow,
                               AFormulaItem.RangeRef.LeftCol,
                               AFormulaItem.RangeRef.Flags,
                               rvteRangeRefLeftColAbsolute,
                               rvteRangeRefTopRowAbsolute);

                  CopyCellInfo(AArea3DPtg.rwLast, AArea3DPtg.grbitColLast,
                               AFormulaItem.RangeRef.BottomRow,
                               AFormulaItem.RangeRef.RightCol,
                               AFormulaItem.RangeRef.Flags,
                               rvteRangeRefRightColAbsolute,
                               rvteRangeRefBottomRowAbsolute);

                  Addptg(ptgArea3D, @AArea3DPtg, sizeof(rptgArea3D));
                end;
              end;
            vteitValue:
              begin
                if (AFormulaItem.Value.ValueType = vteInteger) and
                   (AFormulaItem.Value.vInteger >= -32767) and
                   (AFormulaItem.Value.vInteger <= 32767) then
                begin
                  AIntPtg.w := AFormulaItem.Value.vInteger;
                  Addptg(ptgInt, @AIntPtg, sizeof(rptgInt));
                end
                else
                  if (AFormulaItem.Value.ValueType in [vteInteger, vteExtended]) then
                  begin
                    if AFormulaItem.Value.ValueType = vteInteger then
                      ANumPtg.num := AFormulaItem.Value.vInteger
                    else
                      ANumPtg.num := AFormulaItem.Value.vExtended;
                    Addptg(ptgNum, @ANumPtg, sizeof(rptgnum));
                  end
                  else
                  begin
                    S := GetString(AFormulaItem.Value.vString);
                    AStrPtgSize := sizeof(rptgStr) + Length(S) * sizeof(WideChar);
                    GetMem(AStrPtg, AStrPtgSize);
                    try
                      AStrPtg.cch := Length(S);
                      AStrPtg.grbit := 1;
                      StringToWideChar(S,
                                       PWideChar(PChar(AStrPtg) + sizeof(rptgStr)),
                                       Length(S) * sizeof(WideChar));
                    finally
                      FreeMem(AStrPtg);
                    end;
                    Addptg(ptgStr, PChar(AStrPtg), AStrPtgSize);
                  end;
              end;
            vteitBracket: Addptg(ptgParen, nil, 0);
            vteitMissArg: AddPtg(ptgMissArg, nil, 0);
          end;
        end;
      finally
        FreeMem(ATempFormula);
      end;
    end;
  end
  else
  begin
    AFormula := nil;
    AFormulaSize := 0;
  end;
end;
{$ENDIF}

{$IFNDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.WriteRangeToStream(Stream : TStream; Range : TvteXLSRange; CurrentRow : integer; var IndexInCellsOffsArray : integer; var CellsOffs : Tb8DBCELLCellsOffsArray);
{$ELSE}
procedure TvteExcelWriter.WriteRangeToStream(Stream : TStream; Range : IvgrRange; CurrentRow : integer; var IndexInCellsOffsArray : integer; var CellsOffs : Tb8DBCELLCellsOffsArray);
{$ENDIF}
var
  blank : rb8BLANK;
  i,Left : integer;
  number : rb8NUMBER;
  mulblank : pb8MULBLANK;
  labelsst : rb8LABELSST;
  formula : pb8FORMULA;

  procedure AddToCellsOffsArray;
  begin
  if IndexInCellsOffsArray=0 then
    CellsOffs[IndexInCellsOffsArray] := Stream.Position
  else
    CellsOffs[IndexInCellsOffsArray] := Stream.Position-CellsOffs[IndexInCellsOffsArray-1];
  Inc(IndexInCellsOffsArray);
  end;

begin
Left := Range.Place.Left;
if CurrentRow=Range.Place.Top then
  begin
    // write data cell, check cell type
    {$IFNDEF VTK_GRIDREPORT}
    case Range.CellDataType of
      vtecdtNumber:
    {$ELSE}
    if (Range.Formula = '') and (Range.ValueType in [rvtInteger, rvtExtended, rvtDateTime]) then
    {$ENDIF}
        begin
          AddToCellsOffsArray;
          number.rw := CurrentRow;
          number.col := Range.Place.Left;
          {$IFNDEF VTK_GRIDREPORT}
          number.num := Range.Value;
          {$ELSE}
          if Range.ValueType = rvtNull then
            number.num := 0
          else
            number.num := Range.Value;
          {$ENDIF}
          number.ixfe := pXLSRangeRec(Range.ExportData).iXF;
          wbiff(Stream,b8_NUMBER,@number,sizeof(rb8NUMBER));
          Inc(Left);
    {$IFNDEF VTK_GRIDREPORT}
        end;
      vtecdtString:
    {$ELSE}
        end
      else
    if (Range.Formula = '') and (Range.ValueType = rvtString) then
    {$ENDIF}
        begin
          if pXLSRangeRec(Range.ExportData).iSST<>-1 then
            begin
              AddToCellsOffsArray;
              labelsst.rw := CurrentRow;
              labelsst.col := Range.Place.Left;
              labelsst.ixfe := pXLSRangeRec(Range.ExportData).iXF;
              labelsst.isst := pXLSRangeRec(Range.ExportData).iSST;
              wbiff(Stream,b8_LABELSST,@labelsst,sizeof(labelsst));
              Inc(Left);
            end;
    {$IFNDEF VTK_GRIDREPORT}
        end;
      vtecdtFormula:
    {$ELSE}
        end
      else
    if (Range.Formula <> '') then
    {$ENDIF}
        begin
          AddToCellsOffsArray;

          formula := AllocMem(sizeof(rb8FORMULA)+pXLSRangeRec(Range.ExportData).PtgsSize);
          try
            formula.rw := CurrentRow;
            formula.col := Range.Place.Left;
            formula.ixfe := pXLSRangeRec(Range.ExportData).iXF;
            formula.grbit := b8_FORMULA_fAlwaysCalc;//b8_FORMULA_fCalcOnLoad;
            formula.value := 0;
            formula.cce := pXLSRangeRec(Range.ExportData).PtgsSize;
            MoveMemory(PChar(formula)+sizeof(rb8FORMULA),pXLSRangeRec(Range.ExportData).Ptgs,pXLSRangeRec(Range.ExportData).PtgsSize);
            wbiff(Stream,b8_FORMULA,formula,sizeof(rb8FORMULA)+pXLSRangeRec(Range.ExportData).PtgsSize);
            Inc(Left);
          finally
            FreeMem(formula);
          end;
        end;
    {$IFNDEF VTK_GRIDREPORT}
    end;
    {$ENDIF}
  end;

// write blank cells
if Left<Range.Place.Right then
  begin
    AddToCellsOffsArray;
    mulblank := AllocMem(sizeof(rb8MULBLANK)+(Range.Place.Right-Left+1)*2+2);
    try
      mulblank.rw := CurrentRow;
      mulblank.colFirst := Left;
      for i:=0 to Range.Place.Right-Left do
        PWordArray(PChar(mulblank)+sizeof(rb8MULBLANK))^[i] := pXLSRangeRec(Range.ExportData).iXF;
      PWord(PChar(mulblank)+sizeof(rb8MULBLANK)+(Range.Place.Right-Left+1)*2)^ := Range.Place.Right;
      wbiff(Stream,b8_MULBLANK,mulblank,sizeof(rb8MULBLANK)+(Range.Place.Right-Left+1)*2+2);
    finally
      FreeMem(mulblank);
    end;
  end
else
  if Left=Range.Place.Right then
    begin
      AddToCellsOffsArray;
      blank.rw := CurrentRow;
      blank.col := Left;
      blank.ixfe := pXLSRangeRec(Range.ExportData).iXF;
      wbiff(Stream,b8_BLANK,@blank,sizeof(blank));
    end;
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.WriteSheetToStream(Stream : TStream; Sheet : TvteXLSWorksheet);
{$ELSE}
procedure TvteExcelWriter.WriteSheetToStream(Stream : TStream; Sheet : TvgrWorksheet);
{$ENDIF}
var
  s : string;
  bof : rb8BOF;
  guts : rb8GUTS;
  wsbool : rb8WSBOOL;
  header : pb8HEADER;
  footer : pb8FOOTER;
  hcenter : rb8HCENTER;
  vcenter : rb8VCENTER;
  refmode : rb8REFMODE;
  gridset : rb8GRIDSET;
  window2 : rb8WINDOW2;
  calcmode : rb8CALCMODE;
  calccount : rb8CALCCOUNT;
  iteration : rb8ITERATION;
  selection : pb8SELECTION;
  saverecalc : rb8SAVERECALC;
  dimensions : rb8DIMENSIONS;
  defcolwidth : rb8DEFCOLWIDTH;
  printheaders : rb8PRINTHEADERS;
  printgridlines : rb8PRINTGRIDLINES;
  defaultrowheight : rb8DEFAULTROWHEIGHT;

  {$IFNDEF VTK_GRIDREPORT}
  l : TList;
  rw : TvteXLSRow;
  ran : TvteXLSRange;
  {$ELSE}
  l: TInterfaceList;
  rw : IvgrRow;
  ran : IvgrRange;
  {$ENDIF}
  row : rb8ROW;
  bc,i,j : integer;

  index : pb8INDEX;
  INDEXOffs : integer;
  BlocksInSheet : integer;
  IndexInDBCELLsOffs : integer;

  dbcell : rb8DBCELLfull;
  IndexInCellsOffsArray : integer;

  ms : TMemoryStream;
  merge : PChar;
  colinfo : rb8COLINFO;
  FirstRowOffs,SecondRowOffs : integer;

  setup : rb8SETUP;
  topmargin : rb8TOPMARGIN;
  leftmargin : rb8LEFTMARGIN;
  rightmargin : rb8RIGHTMARGIN;
  bottommargin : rb8BOTTOMMARGIN;
  {$IFNDEF VTK_GRIDREPORT}
  horizontalpagebreaks : pb8HORIZONTALPAGEBREAKS;
  {$ENDIF}
begin
ZeroMemory(@bof,sizeof(bof));
bof.vers := b8_BOF_vers;
bof.dt := b8_BOF_dt_Worksheet;
bof.rupBuild := b8_BOF_rupBuild_Excel97;
bof.rupYear := b8_BOF_rupYear_Excel07;
wbiff(Stream,b8_BOF,@bof,sizeof(bof));

if (Sheet.Dimensions.Bottom<>-1) and (Sheet.Dimensions.Top<>-1) then
  begin
    BlocksInSheet := (Sheet.Dimensions.Bottom-Sheet.Dimensions.Top+1) div XLSMaxRowsInBlock;
    if (Sheet.Dimensions.Bottom=Sheet.Dimensions.Top) or (((Sheet.Dimensions.Bottom-Sheet.Dimensions.Top+1) mod XLSMaxRowsInBlock)<>0) then
      Inc(BlocksInSheet);
  end
else
  BlocksInSheet := 0;

index := AllocMem(sizeof(rb8INDEX)+BlocksInSheet*4);
try
  if (Sheet.Dimensions.Bottom<>-1) and (Sheet.Dimensions.Top<>-1) then
    begin
      index.rwMic := Sheet.Dimensions.Top;
      index.rwMac := Sheet.Dimensions.Bottom+1;
    end;
  INDEXOffs := Stream.Position;
  IndexInDBCELLsOffs := 0;
  wbiff(Stream,b8_INDEX,index,sizeof(rb8INDEX)+BlocksInSheet*4); // corrected later

  calcmode.fAutoRecalc := 1; // automatic recalc
  wbiff(Stream,b8_CALCMODE,@calcmode,sizeof(calcmode));
  
  calccount.cIter := $0064; // see in biffview
  wbiff(Stream,b8_CALCCOUNT,@calccount,sizeof(calccount));
  
  refmode.fRefA1 := $0001; // 1 for A1 mode
  wbiff(Stream,b8_REFMODE,@refmode,sizeof(refmode));
  
  iteration.fIter := $0000; // 1 see in biffview
  wbiff(Stream,b8_ITERATION,@iteration,sizeof(iteration));
  
  // DELTA
  s := HexStringToString('10 00 08 00 fc a9 f1 d2 4d 62 50 3f');
  Stream.Write(s[1],length(s));

  saverecalc.fSaveRecalc := $0001; // see in biffview
  wbiff(Stream,b8_SAVERECALC,@saverecalc,sizeof(saverecalc));

  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.PrintHeaders then
    printheaders.fPrintRwCol := 1
  else
  {$ENDIF}
    printheaders.fPrintRwCol := 0;
  wbiff(Stream,b8_PRINTHEADERS,@printheaders,sizeof(printheaders));

  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.PrintGridLines then
    printgridlines.fPrintGrid := 1
  else
  {$ENDIF}
    printgridlines.fPrintGrid := 0;
  wbiff(Stream,b8_PRINTGRIDLINES,@printgridlines,sizeof(printgridlines));

  gridset.fGridSet := $0001; // see in biffview
  wbiff(Stream,b8_GRIDSET,@gridset,sizeof(gridset));

  ZeroMemory(@guts,sizeof(guts));  // all to zero see in biffview
  wbiff(Stream,b8_GUTS,@guts,sizeof(guts));

  defaultrowheight.grbit := $0000; // see in biffview
  defaultrowheight.miyRw := xlsDefaultRowHeight; // see in biffview
  wbiff(Stream,b8_DEFAULTROWHEIGHT,@defaultrowheight,sizeof(defaultrowheight));

  // write info about pagebreaks
  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageBreaksCount>0 then
    begin
      horizontalpagebreaks := AllocMem(sizeof(rb8HORIZONTALPAGEBREAKS)+sizeof(rb8HORIZONTALPAGEBREAK)*Sheet.PageBreaksCount);
      try
        horizontalpagebreaks.cbrk := Sheet.PageBreaksCount;
        for i:=0 to Sheet.PageBreaksCount-1 do
          with pb8HORIZONTALPAGEBREAK(PChar(horizontalpagebreaks)+2+i*sizeof(rb8HORIZONTALPAGEBREAK))^ do
            begin
              row := Sheet.PageBreaks[i];
              startcol := 0;
              endcol := 255;
            end;
        wbiff(Stream,b8_HORIZONTALPAGEBREAKS,horizontalpagebreaks,sizeof(rb8HORIZONTALPAGEBREAKS)+sizeof(rb8HORIZONTALPAGEBREAK)*Sheet.PageBreaksCount);
      finally
        FreeMem(horizontalpagebreaks);
      end;
    end;
  {$ENDIF}

  wsbool.grbit := $04C1; // see in biffview
  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.UseScale then
    wsbool.grbit := wsbool.grbit and not b8_WSBOOL_fFitToPage
  else
    wsbool.grbit := wsbool.grbit or b8_WSBOOL_fFitToPage;
  {$ELSE}
  wsbool.grbit := wsbool.grbit and not b8_WSBOOL_fFitToPage;
  {$ENDIF}
  wbiff(Stream,b8_WSBOOL,@wsbool,sizeof(wsbool));

  s := '';
  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.LeftHeader<>'' then
    s := s+'&L'+Sheet.PageSetup.LeftHeader;
  if Sheet.PageSetup.CenterHeader<>'' then
    s := s+'&C'+Sheet.PageSetup.CenterHeader;
  if Sheet.PageSetup.RightHeader<>'' then
    s := s+'&R'+Sheet.PageSetup.RightHeader;
  {$ENDIF}
  if s<>'' then
    begin
      GetMem(header,sizeof(rb8HEADER)+Length(s)*2);
      try
        header.cch := Length(s);
        header.cchgrbit := 1;
        StringToWideChar(s,PWideChar(PChar(header)+sizeof(rb8HEADER)),Length(s)*2);
        wbiff(Stream,b8_HEADER,header,sizeof(rb8HEADER)+Length(s)*2);
      finally
        FreeMem(header);
      end;
    end
  else
    begin
      wbiff(Stream,b8_HEADER,nil,0);
    end;

  s := '';
  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.LeftFooter<>'' then
    s := s+'&L'+Sheet.PageSetup.LeftFooter;
  if Sheet.PageSetup.CenterFooter<>'' then
    s := s+'&C'+Sheet.PageSetup.CenterFooter;
  if Sheet.PageSetup.RightFooter<>'' then
    s := s+'&R'+Sheet.PageSetup.RightFooter;
  {$ENDIF}
  if s<>'' then
    begin
      GetMem(footer,sizeof(rb8FOOTER)+Length(s)*2);
      try
        footer.cch := Length(s);
        footer.cchgrbit := 1;
        StringToWideChar(s,PWideChar(PChar(footer)+sizeof(rb8HEADER)),Length(s)*2);
        wbiff(Stream,b8_FOOTER,footer,sizeof(rb8FOOTER)+Length(s)*2);
      finally
        FreeMem(footer);
      end;
    end
  else
    begin
      wbiff(Stream,b8_FOOTER,nil,0);
    end;

  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.CenterHorizontally then
    hcenter.fHCenter := 1
  else
  {$ENDIF}
    hcenter.fHCenter := 0;
  wbiff(Stream,b8_HCENTER,@hcenter,sizeof(hcenter));

  {$IFNDEF VTK_GRIDREPORT}
  if Sheet.PageSetup.CenterVertically then
    vcenter.fVCenter := 1
  else
  {$ENDIF}
    vcenter.fVCenter := 0;
  wbiff(Stream,b8_VCENTER,@vcenter,sizeof(vcenter));

  // page margins
  {$IFNDEF VTK_GRIDREPORT}
  leftmargin.num := Sheet.PageSetup.LeftMargin;
  {$ELSE}
  leftmargin.num := Sheet.PageProperties.Margins.Left/TwipsPerInch;
  {$ENDIF}
  wbiff(Stream,b8_LEFTMARGIN,@leftmargin,sizeof(rb8LEFTMARGIN));
  {$IFNDEF VTK_GRIDREPORT}
  rightmargin.num := Sheet.PageSetup.RightMargin;
  {$ELSE}
  rightmargin.num := Sheet.PageProperties.Margins.right/TwipsPerInch;
  {$ENDIF}
  wbiff(Stream,b8_RIGHTMARGIN,@rightmargin,sizeof(rb8RIGHTMARGIN));
  {$IFNDEF VTK_GRIDREPORT}
  topmargin.num := Sheet.PageSetup.TopMargin;
  {$ELSE}
  topmargin.num := Sheet.PageProperties.Margins.top/TwipsPerInch;
  {$ENDIF}
  wbiff(Stream,b8_TOPMARGIN,@topmargin,sizeof(rb8TOPMARGIN));
  {$IFNDEF VTK_GRIDREPORT}
  bottommargin.num := Sheet.PageSetup.BottomMargin;
  {$ELSE}
  bottommargin.num := Sheet.PageProperties.Margins.bottom/TwipsPerInch;
  {$ENDIF}
  wbiff(Stream,b8_BOTTOMMARGIN,@bottommargin,sizeof(rb8BOTTOMMARGIN));

  // SETUP - skipped
  ZeroMemory(@setup,sizeof(rb8SETUP));
  {$IFNDEF VTK_GRIDREPORT}
  setup.iPaperSize := word(Sheet.PageSetup.PaperSize);
  setup.iPageStart := Sheet.PageSetup.FirstPageNumber;
  setup.iFitWidth := Sheet.PageSetup.FitToPagesWide;
  setup.iFitHeight := Sheet.PageSetup.FitToPagesTall;
  setup.numHdr := Sheet.PageSetup.HeaderMargin;
  setup.numFtr := Sheet.PageSetup.FooterMargin;
  setup.iCopies := Sheet.PageSetup.Copies;
  setup.iScale := Sheet.PageSetup.Zoom;
//  setup.grbit := b8_SETUP_fNoPls;
  if Sheet.PageSetup.Order=vtexlOverThenDown then
    setup.grbit := setup.grbit or b8_SETUP_fLeftToRight;
  if Sheet.PageSetup.Orientation=vtexlPortrait then
    setup.grbit := setup.grbit or b8_SETUP_fLandscape;
  if Sheet.PageSetup.BlackAndWhite then
    setup.grbit := setup.grbit or b8_SETUP_fNoColor;
  if Sheet.PageSetup.Draft then
    setup.grbit := setup.grbit or b8_SETUP_fDraft;
  if Sheet.PageSetup.PrintNotes then
    setup.grbit := setup.grbit or b8_SETUP_fNotes;
  if Sheet.PageSetup.FirstPageNumber<>1 then
    setup.grbit := setup.grbit or b8_SETUP_fUsePage;
  {$ELSE}
  setup.grbit := $0083; // see in biffview
//  setup.grbit := setup.grbit or b8_WSBOOL_fFitToPage;
  setup.iPaperSize := word(vtexlPaperA4);
  setup.iPageStart := 1;
  setup.iFitWidth := 1;
  setup.iFitHeight := 1;
  setup.numHdr := 0;
  setup.numFtr := 0;
  setup.iCopies := 1;
  setup.grbit := setup.grbit or b8_SETUP_fLandscape;
  setup.iScale := 100;
  {$ENDIF}
  wbiff(Stream,b8_SETUP,@setup,sizeof(rb8SETUP));

  defcolwidth.cchdefColWidth := XLSDefaultColumnWidthInChars; // see in biffview
  wbiff(Stream,b8_DEFCOLWIDTH,@defcolwidth,sizeof(defcolwidth));

  // now write columns info
  for i:=0 to Sheet.ColsCount-1 do
    with Sheet.ColByIndex[i] do
      begin
        ZeroMemory(@colinfo,sizeof(colinfo));
        {$IFNDEF VTK_GRIDREPORT}
        colinfo.colFirst := Ind;
        colinfo.colLast := Ind;
        colinfo.coldx := Width;
        {$ELSE}
        colinfo.colFirst := Number;
        colinfo.colLast := Number;
        colinfo.coldx := (width * 8 * 294) div cDefaultColWidthTwips;
        {$ENDIF}
        wbiff(Stream,b8_COLINFO,@colinfo,sizeof(colinfo));
      end;

  ZeroMemory(@dimensions,sizeof(dimensions));
  if (Sheet.Dimensions.Left<>-1) and
     (Sheet.Dimensions.Right<>-1) and
     (Sheet.Dimensions.Top<>-1) and
     (Sheet.Dimensions.Bottom<>-1) then
    begin
      dimensions.rwMic := Sheet.Dimensions.Top;
      dimensions.rwMac := Sheet.Dimensions.Bottom+1;
      dimensions.colMic := Sheet.Dimensions.Left;
      dimensions.colMac := Sheet.Dimensions.Right+1;
    end;
  wbiff(Stream,b8_DIMENSIONS,@dimensions,sizeof(dimensions));

  // here must be writted cells
  if (Sheet.Dimensions.Top<>-1) and (Sheet.Dimensions.Bottom<>-1) then
    begin
      l := TInterfaceList.Create;
      ms := TMemoryStream.Create;
      try
        bc := 0;
        FirstRowOffs := 0;
        SecondRowOffs := 0;
        for i:=Sheet.Dimensions.Top to Sheet.Dimensions.Bottom do
          begin
            // finding all regions what placed over row [i]
            l.Clear;
            for j:=0 to Sheet.RangesCount-1 do
              begin
                ran := Sheet.RangeByIndex[j];
                if (ran.Place.Top<=i) and (i<=ran.Place.Bottom) then
                  l.Add(ran);
              end;
//            l.Sort(sort);
            // write row i to file
            if bc=0 then
              FirstRowOffs := Stream.Position;
            row.rw := i;
            if l.Count>0 then
              begin
                {$IFNDEF VTK_GRIDREPORT}
                row.colMic := TvteXLSRange(l[0]).Place.Left;
                row.colMac := TvteXLSRange(l[l.Count-1]).Place.Right+1;
                {$ELSE}
                row.colMic := IvgrRange(l[0]).Place.Left;
                row.colMac := IvgrRange(l[l.Count-1]).Place.Right+1;
                {$ENDIF}
              end
            else
              begin
                row.colMic := 0;
                row.colMac := 0;
              end;
            // to determine row height find TvteXLSRow, if not found
            // simple set default height
            {$IFNDEF VTK_GRIDREPORT}
            rw := Sheet.FindRow(i);
            {$ELSE}
            rw := Sheet.RowsList.Find(i);
            {$ENDIF}
            if rw=nil then
              begin
                row.miyRw := XLSDefaultRowHeight;
                row.grbit := 0;
              end
            else
              begin
                {$IFNDEF VTK_GRIDREPORT}
                row.miyRw := rw.Height;
                {$ELSE}
                row.miyRw := TwipsToPoints(rw.Height * 20);
                {$ENDIF}
                row.grbit := b8_ROW_grbit_fUnsynced;
              end;
            wbiff(Stream,b8_ROW,@row,sizeof(row));
            if bc=0 then
              SecondRowOffs := Stream.Position;

            // write row cells to temporary memorystream,
            // also save cell offset from SecondRowOffs to CellsOffs
            IndexInCellsOffsArray := 0;
            for j:=0 to l.Count-1 do
              {$IFNDEF VTK_GRIDREPORT}
              WriteRangeToStream(ms,TvteXLSRange(l[j]),i,IndexInCellsOffsArray,dbcell.CellsOffs);
              {$ELSE}
              WriteRangeToStream(ms,IvgrRange(l[j]),i,IndexInCellsOffsArray,dbcell.CellsOffs);
              {$ENDIF}

            Inc(bc);
            if (bc=XLSMaxRowsInBlock) or (i=Sheet.Dimensions.Bottom) then
              begin
                dbcell.CellsOffs[0] := Stream.Position-SecondRowOffs;
                // write from temporary memorystream to Stream
                ms.SaveToStream(Stream);
                // rows block ended - write DBCELL
                // save DBCell offset
                PCardinalArray(PChar(index)+sizeof(rb8INDEX))^[IndexInDBCELLsOffs] := Stream.Position-FBOFOffs;
                Inc(IndexInDBCELLsOffs);

                dbcell.dbRtrw := Stream.Position-FirstRowOffs;
                wbiff(Stream,b8_DBCELL,@dbcell,sizeof(rb8DBCELL)+IndexInCellsOffsArray*2);
                // reinit vars
                ms.Clear;
                bc := 0;
              end;
          end;
      finally
        l.Free;
        ms.Free;
      end;

      // correct index record
      Stream.Position := INDEXOffs;
      wbiff(Stream,b8_INDEX,index,sizeof(rb8INDEX)+BlocksInSheet*4);
      Stream.Seek(0,soFromEnd);
    end;
finally
  FreeMem(index);
end;

// write info about images on sheet
{$IFNDEF VTK_GRIDREPORT}
WriteSheetImagesToStream(Stream,Sheet);
{$ENDIF}

ZeroMemory(@window2,sizeof(window2));
window2.grbit := b8_WINDOW2_grbit_fPaged or // $06B6 - this value see in biffview
                 b8_WINDOW2_grbit_fDspGuts or
                 b8_WINDOW2_grbit_fDspZeros or
                 b8_WINDOW2_grbit_fDefaultHdr or
                 b8_WINDOW2_grbit_fDspGrid or
                 b8_WINDOW2_grbit_fDspRwCol;
if Sheet.IndexInWorkBook=0 then
  window2.grbit := window2.grbit+b8_WINDOW2_grbit_fSelected;
window2.rwTop := 0;
window2.colLeft := 0;
window2.icvHdr := $00000040;
window2.wScaleSLV := 0;
window2.wScaleNormal := 0;
wbiff(Stream,b8_WINDOW2,@window2,sizeof(window2));

selection := AllocMem(sizeof(rb8SELECTION)+6);
try
  selection.pnn := 3; // see in biffview
  selection.cref := 1;
  wbiff(Stream,b8_SELECTION,selection,sizeof(rb8SELECTION)+6);
finally
  FreeMem(selection);
end;

// write data about merge ranges
if Sheet.RangesCount>0 then
  begin
    j := 0;
    for i:=0 to Sheet.RangesCount-1 do
      begin
        ran := Sheet.RangeByIndex[i];
        if (ran.Place.Left<>ran.Place.Right) or
           (ran.Place.Top<>ran.Place.Bottom) then
          Inc(j);
      end;
    if j>0 then
      begin
        merge := AllocMem(sizeof(rb8MERGE)+mergeBlockItemsCount*sizeof(rb8MERGErec));
        try
          j := 0;
          for i:=0 to Sheet.RangesCount-1 do
            begin
              ran := Sheet.RangeByIndex[i];
              if (ran.Place.Left<>ran.Place.Right) or (ran.Place.Top<>ran.Place.Bottom) then
                begin
                  if j>=mergeBlockItemsCount then
                    begin
                      pb8MERGE(merge).cnt := mergeBlockItemsCount;
                      wbiff(Stream,b8_MERGE,merge,sizeof(rb8MERGE)+mergeBlockItemsCount*sizeof(rb8MERGErec));
                      j := 0;
                    end;
                  with pb8MERGErec(PChar(merge)+sizeof(rb8MERGE)+j*8)^ do
                    begin
                      top := ran.Place.Top;
                      bottom := ran.Place.Bottom;
                      left := ran.Place.Left;
                      right := ran.Place.Right;
                    end;
                  Inc(j);
                end;
            end;

          if j<>0 then
            begin
              pb8MERGE(merge).cnt := j;
              wbiff(Stream,b8_MERGE,merge,sizeof(rb8MERGE)+j*sizeof(rb8MERGErec));
            end;
        finally
          FreeMem(merge);
        end;
      end;
  end;

wbiff(Stream,b8_EOF,nil,0);
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.BuildImagesColorsIndexes;
var
  i,j,n : integer;
begin
n := 0;
for i:=0 to FWorkbook.SheetsCount-1 do
  for j:=0 to FWorkbook.Sheets[i].Images.Count-1 do
    with FWorkbook.Sheets[i].Images[j],FImagesRecs[n] do
      begin
        BorderLineColorIndex := GetColorPaletteIndex(BorderLineColor);
        ForegroundFillPatternColorIndex := GetColorPaletteIndex(clWhite);
        BackgroundFillPatternColorIndex := GetColorPaletteIndex(clWhite);
        Inc(n);
      end;
end;

procedure TvteExcelWriter.WriteSheetImagesToStream(Stream : TStream; Sheet : TvteXLSWorksheet);
const
  aBorderLineStyles : array [TvteXLSImageBorderLineStyle] of byte = (0,1,2,3,4,5,6,7,8);
  aBorderLineWeight : array [TvteXLSImageBorderLineWeight] of byte = (0,1,2,3);
var
  ms : TMemoryStream;
  mf : TMetaFile;
  mfc : TMetaFileCanvas;
  obj : pb8OBJ;
  img : TvteImage;
  pir : pXLSImageRec;
  imdata : rb8IMDATA;
  i,n,k,w : integer;
  objpicture : pb8OBJPICTURE;

  function GetColWidth(ColIndex : integer) : integer;
  var
    c : TvteXLSCol;
  begin
  c := Sheet.FindCol(ColIndex);
  if c<>nil then
    Result := c.PixelWidth
  else
    Result := Sheet.GetDefaultColumnPixelWidth;
  end;

  function GetRowHeight(RowIndex : integer) : integer;
  var
    r : TvteXLSRow;
  begin
  r := Sheet.FindRow(RowIndex);
  if r<>nil then
    Result := r.PixelHeight
  else
    Result := Sheet.GetDefaultRowPixelHeight;
  end;

begin
obj := AllocMem(sizeof(rb8OBJ)+sizeof(rb8OBJPICTURE));
objpicture := pb8OBJPICTURE(PChar(obj)+sizeof(rb8OBJ));
ms := TMemoryStream.Create;
try
  n := 0;
  for i:=0 to Sheet.IndexInWorkBook-1 do
    n := n+Sheet.Workbook.Sheets[i].Images.Count;
  for i:=0 to Sheet.Images.Count-1 do
    begin
      // write OBJ
      img := Sheet.Images[i];
      pir := @FImagesRecs[n];
      ZeroMemory(obj,sizeof(rb8OBJ)+sizeof(rb8OBJPICTURE));
      OBJ.cObj := Sheet.Images.Count;
      OBJ.OT := b8_OBJ_OT_PictureObject;
      OBJ.id := i+1;
      OBJ.grbit := b8_OBJ_grbit_fVisible or b8_OBJ_grbit_fPrint or b8_OBJ_grbit_fMove or b8_OBJ_grbit_fLocked;
      OBJ.colL := img.Left;
      OBJ.dxL := img.LeftCO;
      OBJ.rwT := img.Top;
      OBJ.dyT := img.TopCO;
      if img.ScalePercentX>0 then
        begin
          OBJ.colR := img.Left;
          k := MulDiv(img.Picture.Width,img.ScalePercentX,100)+MulDiv(GetColWidth(OBJ.colR),img.LeftCO,1024);
          repeat
            w := GetColWidth(OBJ.colR);
            k := k-w;
            OBJ.colR := OBJ.colR+1;
          until k<=0;
          if k<0 then
            begin
              Dec(OBJ.colR);
              OBJ.dxR := MulDiv(k+w,1024,w);
            end
          else
            OBJ.dxR := 0;
        end
      else
        begin
          OBJ.colR := img.Right;
          OBJ.dxR := img.RightCO;
        end;
      if img.ScalePercentY>0 then
        begin
          OBJ.rwB := img.Top;
          k := MulDiv(img.Picture.Height,img.ScalePercentY,100)+MulDiv(GetRowHeight(OBJ.rwB),img.TopCO,256{1024});
          repeat
            w := GetRowHeight(OBJ.rwB);
            k := k-w;
            OBJ.rwB := OBJ.rwB+1;
          until k<=0;
          if k<0 then
            begin
              Dec(OBJ.rwB);
              OBJ.dyB := MulDiv(k+w,256{1024},w);
            end
          else
            OBJ.dyB := 0;
        end
      else
        begin
          OBJ.rwB := img.Bottom;
          OBJ.dyB := img.BottomCO;
        end;
      OBJ.cbMacro := 0;

      objpicture.icvBack := pir.BackgroundFillPatternColorIndex;
      objpicture.icvFore := pir.ForegroundFillPatternColorIndex;
      objpicture.fls := 1;  // !!! If here 0 those images can be selected only by clicking on it to border
      objpicture.fAutoFill := 0;
      objpicture.icv := pir.BorderLineColorIndex;
      objpicture.lns := aBorderLineStyles[img.BorderLineStyle];
      objpicture.lnw := aBorderLineWeight[img.BorderLineWeight];
      objpicture.fAutoBorder := 0;
      objpicture.frs := 0;
      objpicture.cf := $02;
      objpicture.Reserved1 := 0;
      objpicture.cbPictFmla := 0;
      objpicture.Reserved2 := 0;
      objpicture.grbit := 0;
      objpicture.Reserved3 := 0;
      wbiff(Stream,b8_OBJ,obj,sizeof(rb8OBJ)+sizeof(rb8OBJPICTURE));

      ms.Clear;
      imdata.cf := $02;
      imdata.env := 1;
      imdata.lcb := 0;
      ms.Write(imdata,sizeof(imdata));

      mf := TMetaFile.Create;
      try
        mf.Width := img.Picture.Graphic.Width;
        mf.Height := img.Picture.Graphic.Height;
        mfc := TMetaFileCanvas.Create(mf,0);
        mfc.Draw(0,0,img.Picture.Graphic);
        mfc.Free;
        mf.SaveToStream(ms);
      finally
        mf.Free;
      end;
      imdata.lcb := ms.Size-sizeof(rb8IMDATA);
      ms.Position := 4;
      ms.Write(imdata.lcb,4);
      wbiff(Stream,b8_IMDATA,ms.Memory,ms.Size);
      Inc(n);
    end;
finally
  ms.Free;
  FreeMem(obj);
end;
end;
{$ENDIF}


{$IFNDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.SaveAsBIFFToStream(WorkBook : TvteXLSWorkbook; Stream : TStream);
{$ELSE}
procedure TvteExcelWriter.SaveAsBIFFToStream(WorkBook : TvgrWorkbook; Stream : TStream);
{$ENDIF}
var
  sstsizeoffset,ltitleoffset,sstblockoffset,lsstbuf,sstsize,extsstsize : integer;
  i,j,k,m,ltitle,RangesCount : integer;
  s : string;
  l : TList;
  sl : TStringList;
  {$IFNDEF VTK_GRIDREPORT}
  sh : TvteXLSWorksheet;
  {$ELSE}
  sh : TvgrWorksheet;
  {$ENDIF}
  bof : rb8BOF;
  mms : rb8MMS;
  codepage : rb8CODEPAGE;
  interfachdr : rb8INTERFACHDR;
  fngroupcount : rb8FNGROUPCOUNT;
  windowprotect : rb8WINDOWPROTECT;
  protect : rb8PROTECT;
  password : rb8PASSWORD;
  backup : rb8BACKUP;
  hideobj : rb8HIDEOBJ;
  s1904 : rb81904;
  precision : rb8PRECISION;
  bookbool : rb8BOOKBOOL;
  writeaccess : rb8WRITEACCESS;
  doublestreamfile : rb8DOUBLESTREAMFILE;
  prot4rev : rb8PROT4REV;
  prot4revpass : rb8PROT4REVPASS;
  window1 : rb8WINDOW1;
  refreshall : rb8REFRESHALL;
  useselfs : rb8USESELFS;
  boundsheet : pb8BOUNDSHEET;
  country : rb8COUNTRY;
  palette : rb8PALETTE;
  sst,sstbuf : PChar;
  extsst : pb8EXTSST;
  supbook : pb8SUPBOOK;
  externsheet : pb8EXTERNSHEET;
  xti : pb8XTI;
  sz : word;
  buf : pointer;

  procedure AddDefXF(const HexString : string);
  var
    s : string;
    buf : pointer;
  begin
  s := HexStringToString(HexString);
  GetMem(buf,Length(s));
  CopyMemory(buf,@(s[1]),Length(s));
  l.Add(buf);
  end;

begin
FWorkBook := WorkBook;
RangesCount := 0;
k := 0;
{$IFNDEF VTK_GRIDREPORT}
for i:=0 to FWorkBook.SheetsCount-1 do
{$ELSE}
for i:=0 to FWorkBook.WorkSheetsCount-1 do
{$ENDIF}
  begin
    {$IFNDEF VTK_GRIDREPORT}
    RangesCount := RangesCount+FWorkBook.Sheets[i].RangesCount;
    k := k+FWorkbook.Sheets[i].Images.Count;
    {$ELSE}
    RangesCount := RangesCount+FWorkBook.WorkSheets[i].RangesCount;
    {$ENDIF}
  end;
GetMem(FRangesRecs,RangesCount*sizeof(rXLSRangeRec));
{$IFNDEF VTK_GRIDREPORT}
GetMem(FSheetsRecs,FWorkBook.SheetsCount*sizeof(rXLSSheetRec));
{$ELSE}
GetMem(FSheetsRecs,FWorkBook.WorkSheetsCount*sizeof(rXLSSheetRec));
{$ENDIF}
GetMem(FImagesRecs,k*sizeof(rXLSImageRec));
try
  // set palette to default values
  CopyMemory(@FColorPalette[0],@aDefaultColorPalette[0],XLSMaxColorsInPalette*4);
  FPaletteModified := false;
  FUsedColors.Clear;
  
  FBOFOffs := Stream.Position;
  ZeroMemory(@bof,sizeof(bof));
  bof.vers := b8_BOF_vers;
  bof.dt := b8_BOF_dt_WorkbookGlobals;
  bof.rupBuild := b8_BOF_rupBuild_Excel97;
  bof.rupYear := b8_BOF_rupYear_Excel07;
  bof.sfo := b8_BOF_vers;
  wbiff(Stream,b8_BOF,@bof,sizeof(bof));
  
  interfachdr.cv := b8_INTERFACHDR_cv_ANSI;
  wbiff(Stream,b8_INTERFACHDR,@interfachdr,sizeof(interfachdr));

  ZeroMemory(@mms,sizeof(mms));
  wbiff(Stream,b8_MMS,@mms,sizeof(mms));
  wbiff(Stream,b8_INTERFACEND,nil,0);
  
  FillMemory(@writeaccess,sizeof(writeaccess),32);
  {$IFNDEF VTK_GRIDREPORT}
  StringToWideChar(WorkBook.UserNameOfExcel,@writeaccess.stName,sizeof(writeaccess));
  {$ELSE}
  StringToWideChar('',@writeaccess.stName,sizeof(writeaccess));
  {$ENDIF}
  wbiff(Stream,b8_WRITEACCESS,@writeaccess,sizeof(writeaccess));
  
  codepage.cv := b8_CODEPAGE_cv_ANSI;
  wbiff(Stream,b8_CODEPAGE,@codepage,sizeof(codepage));

  doublestreamfile.fDSF := 0;
  wbiff(Stream,b8_DOUBLESTREAMFILE,@doublestreamfile,sizeof(doublestreamfile));
  
  // see in biffview, not found in MSDN
  wbiff(Stream,$01C0,nil,0);

  {$IFNDEF VTK_GRIDREPORT}
  GetMem(buf,WorkBook.SheetsCount*2);
  {$ELSE}
  GetMem(buf,WorkBook.WorkSheetsCount*2);
  {$ENDIF}
  try
    {$IFNDEF VTK_GRIDREPORT}
    for i:=0 to WorkBook.SheetsCount-1 do
    {$ELSE}
    for i:=0 to WorkBook.WorkSheetsCount-1 do
    {$ENDIF}
      PWordArray(buf)^[i] := i+1;
    {$IFNDEF VTK_GRIDREPORT}
    wbiff(Stream,b8_TABID,buf,WorkBook.SheetsCount*2);
    {$ELSE}
    wbiff(Stream,b8_TABID,buf,WorkBook.WorkSheetsCount*2);
    {$ENDIF}
  finally
    FreeMem(buf);
  end;
  fngroupcount.cFnGroup := $000E; // viewed in biffview
  wbiff(Stream,b8_FNGROUPCOUNT,@fngroupcount,sizeof(fngroupcount));
  
  windowprotect.fLockWn := 0; // viewed in biffview
  wbiff(Stream,b8_WINDOWPROTECT,@windowprotect,sizeof(windowprotect));
  
  protect.fLock := 0; // viewed in biffview
  wbiff(Stream,b8_PROTECT,@protect,sizeof(protect));

  password.wPassword := 0; // viewed in biffview
  wbiff(Stream,b8_PASSWORD,@password,sizeof(password));

  prot4rev.fRevLock := 0; // see in biffview
  wbiff(Stream,b8_PROT4REV,@prot4rev,sizeof(prot4rev));

  prot4revpass.wrevPass := 0; // see in biffview
  wbiff(Stream,b8_PROT4REVPASS,@prot4revpass,sizeof(prot4revpass));
  
  ZeroMemory(@window1,sizeof(window1));
  window1.xWn := $0168;
  window1.yWn := $001E;
  window1.dxWn := $1D1E;
  window1.dyWn := $1860;
  window1.grbit := $0038;
  window1.itabCur := $0000;
  window1.itabFirst := $0000;
  window1.ctabSel := $0001;
  window1.wTabRatio := $0258;
  wbiff(Stream,b8_WINDOW1,@window1,sizeof(window1));
  
  backup.fBackupFile := 0;  // set to 1 to enable backup
  wbiff(Stream,b8_BACKUP,@backup,sizeof(backup));
  
  hideobj.fHideObj := 0;  // viewed in biffview
  wbiff(Stream,b8_HIDEOBJ,@hideobj,sizeof(hideobj));
  
  s1904.f1904 := 0; // = 1 if the 1904 date system is used
  wbiff(Stream,b8_1904,@s1904,sizeof(s1904));

  precision.fFullPrec := 1; // viewed in biffview
  wbiff(Stream,b8_PRECISION,@precision,sizeof(precision));
  
  refreshall.fRefreshAll := 0;
  wbiff(Stream,b8_REFRESHALL,@refreshall,sizeof(refreshall));
  
  bookbool.fNoSaveSupp := 0; // viewed in biffview
  wbiff(Stream,b8_BOOKBOOL,@bookbool,sizeof(bookbool));

  // FONTS
  l := TList.Create;
  try
    // 1. Add default font records
    for i:=0 to 3 do
      with TFont(L[L.Add(TFont.Create)]) do
        begin
          Name := vteDefFontFace;
          Size := vteDefFontSize;
        end;
    // 2. Build list of unique FONT records and write them
    // and init ExportData
    BuildFontList(l);
    // 3. write fonts
    for i:=0 to l.Count-1 do
      wbiffFont(Stream,TFont(l[i]),GetColorPaletteIndex(TFont(l[i]).Color));
  finally
    for i:=0 to l.Count-1 do
      TFont(l[i]).Free;
    l.Free;
  end;
  
  // FORMATS
  sl := TStringList.Create;
  try
    // 1. Add default format records
    sl.AddObject('#,##0"�.";\-#,##0"�."',pointer($0005));
    sl.AddObject('#,##0"�.";[Red]\-#,##0"�."',pointer($0006));
    sl.AddObject('#,##0.00"�.";\-#,##0.00"�."',pointer($0007));
    sl.AddObject('#,##0.00"�.";[Red]\-#,##0.00"�."',pointer($0008));
    sl.AddObject('_-* #,##0"�."_-;\-* #,##0"�."_-;_-* "-""�."_-;_-@_-',pointer($002A));
    sl.AddObject('_-* #,##0_�_._-;\-* #,##0_�_._-;_-* "-"_�_._-;_-@_-',pointer($0029));
    sl.AddObject('_-* #,##0.00"�."_-;\-* #,##0.00"�."_-;_-* "-"??"�."_-;_-@_-',pointer($002C));
    sl.AddObject('_-* #,##0.00_�_._-;\-* #,##0.00_�_._-;_-* "-"??_�_._-;_-@_-',pointer($002B));
    // 2. build format records list
    BuildFormatList(sl);
    // 3. write formats
    for i:=0 to sl.Count-1 do
      wbiffFormat(Stream,sl[i],word(sl.Objects[i]));
  finally
    sl.Free;
  end;
  
  // Style XF
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 00 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 01 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 01 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 02 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 02 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');
  wbiffHexString(Stream,'e0 00 14 00 00 00 00 00 f5 ff 20 00 00 f4 00 00 00 00 00 00 00 00 c0 20');

  // XF
  l := TList.Create;
  try
    // 1. Add default XF record
    // this is default BIFF record
    AddDefXF('00 00 00 00 01 00 20 00 00 00 00 00 00 00 00 00 00 00 C0 20');
    // this records not requared (MSDN), but without them file not saved in Excel (Excel raises Access Violation)
    AddDefXF('01 00 2C 00 F5 FF 20 00 00 F8 00 00 00 00 00 00 00 00 C0 20');
    AddDefXF('01 00 2A 00 F5 FF 20 00 00 F8 00 00 00 00 00 00 00 00 C0 20');
    AddDefXF('01 00 09 00 F5 FF 20 00 00 F8 00 00 00 00 00 00 00 00 C0 20');
    AddDefXF('01 00 2B 00 F5 FF 20 00 00 F8 00 00 00 00 00 00 00 00 C0 20');
    AddDefXF('01 00 29 00 F5 FF 20 00 00 F8 00 00 00 00 00 00 00 00 C0 20');

    // 2. Build list of unique XF records and write them
    BuildXFList(l);
    // 3. write XF
    for i:=0 to l.Count-1 do
      wbiff(Stream,b8_XF,l[i],sizeof(rb8XF));
  finally
    for i:=0 to l.Count-1 do
      FreeMem(l[i]);
    l.Free;
  end;

  // STYLE see in biffview, i dont use this ability simple write bytes
  wbiffHexString(Stream,'93 02 04 00 10 80 04 FF');
  wbiffHexString(Stream,'93 02 04 00 11 80 07 FF');
  wbiffHexString(Stream,'93 02 04 00 00 80 00 FF');
  wbiffHexString(Stream,'93 02 04 00 12 80 05 FF');
  wbiffHexString(Stream,'93 02 04 00 13 80 03 FF');
  wbiffHexString(Stream,'93 02 04 00 14 80 06 FF');

  // prepare images colors
  {$IFNDEF VTK_GRIDREPORT}
  BuildImagesColorsIndexes;
  {$ENDIF}

  // PALETTE
  if FPaletteModified then
    begin
      palette.ccv := XLSMaxColorsInPalette;
      for i:=0 to XLSMaxColorsInPalette-1 do
        palette.colors[i] := FColorPalette[i]{ shl 8};
      wbiff(Stream,b8_PALETTE,@palette,sizeof(palette));
    end;

  useselfs.fUsesElfs := 0;
  wbiff(Stream,b8_USESELFS,@useselfs,sizeof(useselfs));
  
  // Sheets information
  {$IFNDEF VTK_GRIDREPORT}
  for i:=0 to FWorkBook.SheetsCount-1 do
    begin
      sh := FWorkBook.Sheets[i];
  {$ELSE}
  for i:=0 to FWorkBook.WorkSheetsCount-1 do
    begin
      sh := FWorkBook.WorkSheets[i];
  {$ENDIF}
      FSheetsRecs[i].StreamBOFOffsetPosition := Stream.Position+4;
      ltitle := Length(sh.Title)*sizeof(WideChar);
      boundsheet := AllocMem(sizeof(rb8BOUNDSHEET)+ltitle);
      try
        boundsheet.grbit := 0;
        boundsheet.cch := Length(sh.Title);
        boundsheet.cchgrbit := 1;
        if boundsheet.cch>0 then
          StringToWideChar(sh.Title,PWideChar(PChar(boundsheet)+sizeof(rb8BOUNDSHEET)),ltitle);
        wbiff(Stream,b8_BOUNDSHEET,boundsheet,sizeof(rb8BOUNDSHEET)+ltitle);
      finally
        FreeMem(boundsheet);
      end;
    end;

  country.iCountryDef := $07;
  country.iCountryWinIni := $07;
  wbiff(Stream,b8_COUNTRY,@country,sizeof(country));

  // write supbook and externsheet
  BuildFormulas;
  {$IFNDEF VTK_GRIDREPORT}
  if FCompiler.ExtRefs.SheetsCount>0 then
    with FCompiler.ExtRefs do
  {$ELSE}
  if FExtRefs.SheetsCount > 0 then
    with FExtRefs do
  {$ENDIF}
    begin
      // SUPBOOK
      for i:=0 to BooksCount-1 do
        begin
          s := Books[i].Name;
          if s='' then
            begin
              supbook := AllocMem(sizeof(rb8SUPBOOK)-3);
              try
                supbook.cch := $0401;
                supbook.Ctab := Books[i].SheetsCount; // count of sheets
                wbiff(Stream,b8_SUPBOOK,supbook,sizeof(rb8SUPBOOK)-3);
              finally
                FreeMem(supbook);
              end;
            end
          else
            begin
              supbook := AllocMem(sizeof(rb8SUPBOOK)+Length(s)*sizeof(WideChar));
              supbook.Ctab := Books[i].SheetsCount;
              supbook.cch := Length(s)+1;
              supbook.grbit := 1;
              supbook.code := 1;
              StringToWideChar(s,PWideChar(PChar(supbook)+sizeof(rb8SUPBOOK)),Length(s)*sizeof(WideChar));
              k := sizeof(rb8SUPBOOK)+Length(s)*sizeof(WideChar);
              try
                for j:=0 to Books[i].SheetsCount-1 do
                  begin
                    s := Books[i].Sheets[j].Name;
                    ReallocMem(supbook,k+Length(s)*sizeof(WideChar)+2+1);
                    PWord(PChar(supbook)+k)^ := Length(s);
                    k := k+2;
                    PByte(PChar(supbook)+k)^ := 1;
                    k := k+1;
                    StringToWideChar(s,PWideChar(PChar(supbook)+k),Length(s)*sizeof(WideChar));
                    k := k+Length(s)*sizeof(WideChar);
                  end;
                wbiff(Stream,b8_SUPBOOK,supbook,k);
              finally
                FreeMem(supbook);
              end;
            end
        end;
      // EXTERNSHEET
      externsheet := AllocMem(sizeof(rb8EXTERNSHEET)+SheetsCount*sizeof(rb8XTI));
      try
        externsheet.cXTI := SheetsCount;
        for i:=0 to SheetsCount-1 do
          begin
            xti := pb8XTI(PChar(externsheet)+sizeof(rb8EXTERNSHEET)+i*sizeof(rb8XTI));
            xti.iSUPBOOK := Sheets[i].iSUPBOOK;
            if Books[Sheets[i].iSUPBOOK].Name='' then
              begin
                // reference to Self (other Sheet)
                xti.itabFirst := Workbook.WorksheetIndexByTitle(Sheets[i].Name);
                xti.itabLast := xti.itabFirst;
              end
            else
              begin
                // reference to other Workbook
                xti.itabFirst := Sheets[i].itab;
                xti.itabLast := xti.itabFirst;
              end;
          end;
        wbiff(Stream,b8_EXTERNSHET,externsheet,sizeof(rb8EXTERNSHEET)+SheetsCount*sizeof(rb8XTI));
      finally
        FreeMem(externsheet);
      end;
    end;

  // SST build sst table
  extsstsize := sizeof(rb8EXTSST);
  extsst := AllocMem(extsstsize);
  extsst.Dsst := 8;

  sstsize := sizeof(rb8SST)+4;
  sst := AllocMem(sstsize);
  PWord(sst)^ := b8_SST;
  sstsizeoffset := 2;
  PWord(sst+sstsizeoffset)^ := sizeof(rb8SST);
  sstblockoffset := sstsize;
  lsstbuf := 0;
  sstbuf := nil;

  k := 0;
  m := 0;
  try
    {$IFNDEF VTK_GRIDREPORT}
    for i:=0 to FWorkBook.SheetsCount-1 do
      begin
        sh := FWorkBook.Sheets[i];
    {$ELSE}
    for i:=0 to FWorkBook.WorkSheetsCount-1 do
      begin
        sh := FWorkBook.WorkSheets[i];
    {$ENDIF}
        for j:=0 to sh.RangesCount-1 do
          begin
            {$IFNDEF VTK_GRIDREPORT}
            if sh.RangeByIndex[j].CellDataType=vtecdtString then
            {$ELSE}
            if (sh.RangeByIndex[j].Formula = '') and (sh.RangeByIndex[j].ValueType = rvtString) then
            {$ENDIF}

              begin
                s := VarToStr(sh.RangeByIndex[j].Value);
                FRangesRecs[m].iSST := -1;
                if s<>'' then
                  begin
                    FRangesRecs[m].iSST := k;
                    Inc(k);

                    // convert string to UNICODE
                    ltitle := Length(s)*sizeof(WideChar);
                    if lsstbuf<ltitle then
                      begin
                        lsstbuf := ltitle;
                        ReallocMem(sstbuf,lsstbuf);
                      end;
                    StringToWideChar(s,PWideChar(sstbuf),ltitle);

                    if MaxBiffRecordSize-sstblockoffset<=4 then
                      begin
                        // start new CONTINUE record
                        ReallocMem(sst,sstsize+4);
                        PWord(sst+sstsize)^ := b8_CONTINUE;
                        sstsize := sstsize+2;
                        sstsizeoffset := sstsize;
                        PWord(sst+sstsize)^ := 0;
                        sstsize := sstsize+2;
                        sstblockoffset := 4;
                      end;

                    if (k mod 8)=1 then
                      begin
                        ReallocMem(extsst,extsstsize+sizeof(rb8ISSTINF));
                        pb8ISSTINF(PChar(extsst)+extsstsize).cb := sstblockoffset;
                        pb8ISSTINF(PChar(extsst)+extsstsize).ib := Stream.Position+sstsize;
                        pb8ISSTINF(PChar(extsst)+extsstsize).res1 := 0;
                        extsstsize := extsstsize+sizeof(rb8ISSTINF);
                      end;

                    ReallocMem(sst,sstsize+3);
                    PWord(sst+sstsize)^ := Length(s);
                    sstsize := sstsize+2;
                    PByte(sst+sstsize)^ := 1;
                    sstsize := sstsize+1;
                    PWord(sst+sstsizeoffset)^ := PWord(sst+sstsizeoffset)^+3;
                    sstblockoffset := sstblockoffset+3;

                    ltitleoffset := 0;
                    repeat
                      sz := (Min(ltitle-ltitleoffset,MaxBiffRecordSize-sstblockoffset)) and (not 1);
                      ReallocMem(sst,sstsize+sz);
                      CopyMemory(sst+sstsize,sstbuf+ltitleoffset,sz);
                      sstsize := sstsize+sz;
                      sstblockoffset := sstblockoffset+sz;
                      ltitleoffset := ltitleoffset+sz;
                      PWord(sst+sstsizeoffset)^ := PWord(sst+sstsizeoffset)^+sz;
                      if (ltitle>ltitleoffset) and ((MaxBiffRecordSize-sstblockoffset)<=4) then
                        begin
                          // begin CONTINUE record
                          ReallocMem(sst,sstsize+5);
                          PWord(sst+sstsize)^ := b8_CONTINUE;
                          sstsize := sstsize+2;
                          sstsizeoffset := sstsize;
                          PWord(sst+sstsize)^ := 1;
                          sstsize := sstsize+2;
                          PByte(sst+sstsize)^ := 1;
                          sstsize := sstsize+1;
                          sstblockoffset := 5;
                        end;
                    until ltitle<=ltitleoffset;
                  end;
              end;
            Inc(m);
          end;
      end;
    if k<>0 then
      begin
        pb8SST(sst+4).cstTotal := k;
        pb8SST(sst+4).cstUnique := k;
        Stream.Write(sst^,sstsize);
        wbiff(Stream,b8_EXTSST,extsst,extsstsize);
      end;
  finally
    FreeMem(sst);
    FreeMem(sstbuf);
    FreeMem(extsst);
  end;

  wbiff(Stream,b8_EOF,nil,0);

  //
  {$IFNDEF VTK_GRIDREPORT}
  for i:=0 to FWorkBook.SheetsCount-1 do
    begin
      sh := FWorkBook.Sheets[i];
  {$ELSE}
  for i:=0 to FWorkBook.WorkSheetsCount-1 do
    begin
      sh := FWorkBook.WorkSheets[i];
  {$ENDIF}
      FSheetsRecs[i].StreamBOFOffset := Stream.Position;
      WriteSheetToStream(Stream,sh);
    end;

  // updating sheets information
  {$IFNDEF VTK_GRIDREPORT}
  for i:=0 to FWorkBook.SheetsCount-1 do
  {$ELSE}
  for i:=0 to FWorkBook.WorkSheetsCount-1 do
  {$ENDIF}
    begin
      Stream.Position := FSheetsRecs[i].StreamBOFOffsetPosition;
      Stream.Write(FSheetsRecs[i].StreamBOFOffset,4);
    end;

finally
  FUsedColors.Clear;
  FCompiler.Clear;
  for i:=0 to RangesCount-1 do
    if FRangesRecs[i].Ptgs<>nil then
      FreeMem(FRangesRecs[i].Ptgs);
  FreeMem(FRangesRecs);
  FRangesRecs := nil;
  FreeMem(FSheetsRecs);
  FSheetsRecs := nil;
  FreeMem(FImagesRecs);
  FImagesRecs := nil;
end;
end;

{$IFNDEF VTK_GRIDREPORT}
procedure TvteExcelWriter.Save(WorkBook : TvteXLSWorkbook; const FileName : string);
{$ELSE}
procedure TvteExcelWriter.Save(WorkBook : TvgrWorkbook; const FileName : string);
{$ENDIF}
var
  hr : HResult;
  buf : PWideChar;
  Stream : IStream;
  OleStream : TOleStream;
  RootStorage : IStorage;
  {$IFDEF VTK_GRIDREPORT}
  I: Integer;
  {$ENDIF}
begin
{$IFDEF VTK_GRIDREPORT}
for I:= 0 to WorkBook.WorksheetsCount - 1 do
  TvgrWorksheetAccess(WorkBook.Worksheets[I]).PrepareExportData;
{$ENDIF}
GetMem(buf,Length(FileName)*sizeof(WideChar)+1);
System.StringToWideChar(FileName,buf,Length(FileName)*sizeof(WideChar));
hr := StgCreateDocFile(buf,
                       STGM_CREATE or STGM_READWRITE or STGM_DIRECT or STGM_SHARE_EXCLUSIVE,
                       0,RootStorage);
FreeMem(buf);
if hr<>S_OK then
  raise Exception.CreateFmt('StgCreateDocFile error %d',[hr]);
hr := RootStorage.CreateStream('Workbook',
                               STGM_CREATE or STGM_READWRITE or STGM_DIRECT or STGM_SHARE_EXCLUSIVE,
                               0,0,Stream);
if hr<>S_OK then
  raise Exception.CreateFmt('CreateStream error %d',[hr]);

// Create the OleStream.
OleStream := TOleStream.Create(Stream);
try
  // Save the memo's text to the OleStream.
  SaveAsBIFFToStream(WorkBook,OleStream);
finally
  // Release the OleStream stream.
  OleStream.Free;
end;
{$IFDEF VTK_GRIDREPORT}
for I:= 0 to WorkBook.WorksheetsCount - 1 do
  TvgrWorksheetAccess(WorkBook.Worksheets[I]).ClearExportData;
{$ENDIF}
end;


end.

