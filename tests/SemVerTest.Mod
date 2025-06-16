MODULE SemVerTest;

IMPORT SemVer, Out;

TYPE
  TestCase = RECORD
    input: ARRAY 128 OF CHAR;
    valid: BOOLEAN;
  END;

VAR
  v: SemVer.Version;
  ok: BOOLEAN;
  i: INTEGER;
  tests: ARRAY 71 OF TestCase;

PROCEDURE PrintVersion(v: SemVer.Version);
BEGIN
  Out.String("major="); Out.Int(v.Major, 1); Out.String("; ");
  Out.String("minor="); Out.Int(v.Minor, 1); Out.String("; ");
  Out.String("patch="); Out.Int(v.Patch, 1); Out.String("; ");

  Out.String("preRelease=");
  Out.String(v.PreRelease); Out.String("; ");

  Out.String("build=");
  Out.String(v.Build); Out.String("; ");
  Out.Ln;
END PrintVersion;

PROCEDURE PrintBool(b: BOOLEAN);
BEGIN
  IF b THEN Out.String("valid") ELSE Out.String("invalid") END
END PrintBool;

BEGIN
  tests[0].input := "0.0.4";
  tests[0].valid := TRUE;
  tests[1].input := "1.2.3";
  tests[1].valid := TRUE;
  tests[2].input := "10.20.30";
  tests[2].valid := TRUE;
  tests[3].input := "1.1.2-prerelease+meta";
  tests[3].valid := TRUE;
  tests[4].input := "1.1.2+meta";
  tests[4].valid := TRUE;
  tests[5].input := "1.1.2+meta-valid";
  tests[5].valid := TRUE;
  tests[6].input := "1.0.0-alpha";
  tests[6].valid := TRUE;
  tests[7].input := "1.0.0-beta";
  tests[7].valid := TRUE;
  tests[8].input := "1.0.0-alpha.beta";
  tests[8].valid := TRUE;
  tests[9].input := "1.0.0-alpha.beta.1";
  tests[9].valid := TRUE;
  tests[10].input := "1.0.0-alpha.1";
  tests[10].valid := TRUE;
  tests[11].input := "1.0.0-alpha0.valid";
  tests[11].valid := TRUE;
  tests[12].input := "1.0.0-alpha.0valid";
  tests[12].valid := TRUE;
  tests[13].input := "1.0.0-alpha-a.b-c-somethinglong+build.1-aef.1-its-okay";
  tests[13].valid := TRUE;
  tests[14].input := "1.0.0-rc.1+build.1";
  tests[14].valid := TRUE;
  tests[15].input := "2.0.0-rc.1+build.123";
  tests[15].valid := TRUE;
  tests[16].input := "1.2.3-beta";
  tests[16].valid := TRUE;
  tests[17].input := "10.2.3-DEV-SNAPSHOT";
  tests[17].valid := TRUE;
  tests[18].input := "1.2.3-SNAPSHOT-123";
  tests[18].valid := TRUE;
  tests[19].input := "1.0.0";
  tests[19].valid := TRUE;
  tests[20].input := "2.0.0";
  tests[20].valid := TRUE;
  tests[21].input := "1.1.7";
  tests[21].valid := TRUE;
  tests[22].input := "2.0.0+build.1848";
  tests[22].valid := TRUE;
  tests[23].input := "2.0.1-alpha.1227";
  tests[23].valid := TRUE;
  tests[24].input := "1.0.0-alpha+beta";
  tests[24].valid := TRUE;
  tests[25].input := "1.2.3----RC-SNAPSHOT.12.9.1--.12+788";
  tests[25].valid := TRUE;
  tests[26].input := "1.2.3----R-S.12.9.1--.12+meta";
  tests[26].valid := TRUE;
  tests[27].input := "1.2.3----RC-SNAPSHOT.12.9.1--.12";
  tests[27].valid := TRUE;
  tests[28].input := "1.0.0+0.build.1-rc.10000aaa-kk-0.1";
  tests[28].valid := TRUE;
  tests[29].input := "99999999999999999999999.999999999999999999.99999999999999999";
  tests[29].valid := TRUE;
  tests[30].input := "1.0.0-0A.is.legal";
  tests[30].valid := TRUE;

  tests[31].input := "1";
  tests[31].valid := FALSE;
  tests[32].input := "1.2";
  tests[32].valid := FALSE;
  tests[33].input := "1.2.3-0123";
  tests[33].valid := FALSE;
  tests[34].input := "1.2.3-0123.0123";
  tests[34].valid := FALSE;
  tests[35].input := "1.1.2+.123";
  tests[35].valid := FALSE;
  tests[36].input := "+invalid";
  tests[36].valid := FALSE;
  tests[37].input := "-invalid";
  tests[37].valid := FALSE;
  tests[38].input := "-invalid+invalid";
  tests[38].valid := FALSE;
  tests[39].input := "-invalid.01";
  tests[39].valid := FALSE;
  tests[40].input := "alpha";
  tests[40].valid := FALSE;
  tests[41].input := "alpha.beta";
  tests[41].valid := FALSE;
  tests[42].input := "alpha.beta.1";
  tests[42].valid := FALSE;
  tests[43].input := "alpha.1";
  tests[43].valid := FALSE;
  tests[44].input := "alpha+beta";
  tests[44].valid := FALSE;
  tests[45].input := "alpha_beta";
  tests[45].valid := FALSE;
  tests[46].input := "alpha.";
  tests[46].valid := FALSE;
  tests[47].input := "alpha..";
  tests[47].valid := FALSE;
  tests[48].input := "beta";
  tests[48].valid := FALSE;
  tests[49].input := "1.0.0-alpha_beta";
  tests[49].valid := FALSE;
  tests[50].input := "-alpha.";
  tests[50].valid := FALSE;
  tests[51].input := "1.0.0-alpha..";
  tests[51].valid := FALSE;
  tests[52].input := "1.0.0-alpha..1";
  tests[52].valid := FALSE;
  tests[53].input := "1.0.0-alpha...1";
  tests[53].valid := FALSE;
  tests[54].input := "1.0.0-alpha....1";
  tests[54].valid := FALSE;
  tests[55].input := "1.0.0-alpha.....1";
  tests[55].valid := FALSE;
  tests[56].input := "1.0.0-alpha......1";
  tests[56].valid := FALSE;
  tests[57].input := "1.0.0-alpha.......1";
  tests[57].valid := FALSE;
  tests[58].input := "01.1.1";
  tests[58].valid := FALSE;
  tests[59].input := "1.01.1";
  tests[59].valid := FALSE;
  tests[60].input := "1.1.01";
  tests[60].valid := FALSE;
  tests[61].input := "1.2";
  tests[61].valid := FALSE;
  tests[62].input := "1.2.3.DEV";
  tests[62].valid := FALSE;
  tests[63].input := "1.2-SNAPSHOT";
  tests[63].valid := FALSE;
  tests[64].input := "1.2.31.2.3----RC-SNAPSHOT.12.09.1--..12+788";
  tests[64].valid := FALSE;
  tests[65].input := "1.2-RC-SNAPSHOT";
  tests[65].valid := FALSE;
  tests[66].input := "-1.0.3-gamma+b7718";
  tests[66].valid := FALSE;
  tests[67].input := "+justmeta";
  tests[67].valid := FALSE;
  tests[68].input := "9.8.7+meta+meta";
  tests[68].valid := FALSE;
  tests[69].input := "9.8.7-whatever+meta+meta";
  tests[69].valid := FALSE;
  tests[70].input := "99999999999999999999999.999999999999999999.99999999999999999----RC-SNAPSHOT.12.09.1--------------------------------..12";
  tests[70].valid := FALSE;

  FOR i := 0 TO LEN(tests)-1 DO
    Out.String("Test "); Out.Int(i, 1); Out.String(": ");
    Out.String(tests[i].input);

    SemVer.Parse(tests[i].input, v, ok);
    Out.String("; expected="); PrintBool(tests[i].valid);
    Out.String("; actual="); PrintBool(ok); Out.Ln;

    IF ok # tests[i].valid THEN Out.String("Test failed!!!"); Out.Ln; RETURN END;

    IF ok THEN
      PrintVersion(v);
    END;
    Out.Ln;
  END;
  Out.String("Test success!!!"); Out.Ln;
END SemVerTest.
