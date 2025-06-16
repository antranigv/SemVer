MODULE SemVer;

  IMPORT Out;

TYPE
  StringIdentifier = ARRAY 256 OF CHAR;
  Version* = RECORD
    Major*, Minor*, Patch*: INTEGER;
    PreRelease*, Build*: StringIdentifier;
  END;

PROCEDURE IsDigit(ch: CHAR): BOOLEAN;
BEGIN
  RETURN (ch >= '0') & (ch <= '9');
END IsDigit;

PROCEDURE HasLeadingZero(s: ARRAY OF CHAR; i: INTEGER): BOOLEAN;
BEGIN
  RETURN (s[i] = '0') & IsDigit(s[i + 1]);
END HasLeadingZero;

PROCEDURE ParseInt(s: ARRAY OF CHAR; VAR i, n: INTEGER; VAR ok: BOOLEAN);
VAR digit: INTEGER;
BEGIN
  n := 0;
  IF ~IsDigit(s[i]) THEN ok := FALSE; RETURN END;

  WHILE (i < LEN(s)) & IsDigit(s[i]) DO
    digit := ORD(s[i]) - ORD('0');
    n := n * 10 + digit;
    INC(i);
  END;
  ok := TRUE;
END ParseInt;

PROCEDURE IsIdentChar(ch: CHAR): BOOLEAN;
BEGIN
  RETURN ((ch >= '0') & (ch <= '9')) OR
         ((ch >= 'A') & (ch <= 'Z')) OR
         ((ch >= 'a') & (ch <= 'z')) OR
         (ch = '-');
END IsIdentChar;

PROCEDURE ParseIdentifiers(
  s: ARRAY OF CHAR;
  VAR i: INTEGER;
  VAR dest: StringIdentifier;
  checkLeadingZero: BOOLEAN;
  VAR ok: BOOLEAN);
VAR
  j, segLen: INTEGER;
  ch: CHAR;
  isNumeric, hasLeadingZero: BOOLEAN;
BEGIN
  j := 0; ok := FALSE;

  (* Require at least one character *)
  IF (s[i] = '.') OR (s[i] = '+') OR (s[i] = 0X) THEN RETURN END;

  LOOP
    segLen := 0;
    isNumeric := TRUE;
    hasLeadingZero := FALSE;

    (* Empty identifier is invalid *)
    IF (s[i] = '.') OR (s[i] = '+') OR (s[i] = 0X) THEN RETURN END;

    WHILE (s[i] # '.') & (s[i] # '+') & (s[i] # 0X) DO
      ch := s[i];

      IF ~IsIdentChar(ch) THEN RETURN END;

      (* Check for leading-zero numeric identifiers *)
      IF checkLeadingZero THEN
        IF segLen = 0 THEN
          IF ch = '0' THEN hasLeadingZero := TRUE END;
        ELSE
          IF hasLeadingZero & IsDigit(ch) THEN RETURN END;
        END;
        IF ~IsDigit(ch) THEN isNumeric := FALSE END;
      END;

      IF j >= LEN(dest) - 1 THEN RETURN END;
      dest[j] := ch; INC(i); INC(j); INC(segLen);
    END;

    (* Add dot if needed *)
    IF s[i] = '.' THEN
      IF j >= LEN(dest) - 1 THEN RETURN END;
      dest[j] := '.'; INC(i); INC(j);
    ELSE
      EXIT;
    END;
  END;

  dest[j] := 0X;
  ok := TRUE;
END ParseIdentifiers;

PROCEDURE ParsePreRelease(
  s: ARRAY OF CHAR;
  VAR i: INTEGER;
  VAR PreRelease: StringIdentifier;
  VAR ok: BOOLEAN);
BEGIN
  IF s[i] # '-' THEN ok := FALSE; RETURN END;
  INC(i);
  ParseIdentifiers(s, i, PreRelease, TRUE (* checkLeadingZero *), ok);
END ParsePreRelease;

PROCEDURE ParseBuild(
  s: ARRAY OF CHAR;
  VAR i: INTEGER;
  VAR Build: StringIdentifier;
  VAR ok: BOOLEAN);
BEGIN
  IF s[i] # '+' THEN ok := FALSE; RETURN END;
  INC(i);
  ParseIdentifiers(s, i, Build, FALSE (* checkLeadingZero *), ok);
END ParseBuild;


PROCEDURE Parse*(s: ARRAY OF CHAR; VAR v: Version; VAR finalok: BOOLEAN);
VAR
  i:  INTEGER;
  ok: BOOLEAN;
BEGIN
  (* Make sure it's clean *)
  v.Major := 0;
  v.Minor := 0;
  v.Patch := 0;
  v.PreRelease[0] := 0X;
  v.Build[0]      := 0X;

  ok      := FALSE;
  finalok := FALSE;
  i       := 0;

  (* Major *)
  IF HasLeadingZero(s, i) THEN RETURN END;
  ParseInt(s, i, v.Major, ok); IF ~ok THEN RETURN END;
  IF s[i] # '.' THEN RETURN END; INC(i);

  (* Minor *)
  IF HasLeadingZero(s, i) THEN RETURN END;
  ParseInt(s, i, v.Minor, ok); IF ~ok THEN RETURN END;
  IF s[i] # '.' THEN RETURN END; INC(i);

  (* Patch *)
  IF HasLeadingZero(s, i) THEN RETURN END;
  ParseInt(s, i, v.Patch, ok); IF ~ok THEN RETURN END;

  (* PreRelease, if exists *)
  IF s[i] = '-' THEN
    ParsePreRelease(s, i, v.PreRelease, ok)
  END;

  (* Build, if exists *)
  IF s[i] = '+' THEN
    ParseBuild(s, i, v.Build, ok)
  END;

  (* Must end cleanly *)
  IF s[i] # 0X THEN ok := FALSE; RETURN END;

  finalok := TRUE;
END Parse;
END SemVer.
