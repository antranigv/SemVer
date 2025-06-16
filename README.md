# Semantic Versioning for Vishap Oberon Compiler (voc)

A strict, specification-compliant Semantic Versioning parser for [Vishap Oberon](https://vishap.oberon.am).
Designed for use in package managers, version comparison tools, and system-level
Oberon utilities.

## Features

- Parses full SemVer 2.0.0 strings (`MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]`)
- Validates all pre-release and build metadata
- Outputs parsed results into a structured Version record

## Example

Input:
```
1.1.2-prerelease+meta
```

Result (parsed record):
```
major=1;
minor=1;
patch=2;
preRelease=prerelease;
build=meta;
```

## Usage

```
MODULE SemVerExample;
  IMPORT SemVer, Out;
VAR
  v: SemVer.Version;
  ok: BOOLEAN;
BEGIN
  SemVer.Parse("1.2.3-alpha.1+build.5", v, ok);
  IF ok THEN
    Out.String("major="); Out.Int(v.Major, 1); Out.String("; ");
    Out.String("minor="); Out.Int(v.Minor, 1); Out.String("; ");
    Out.String("patch="); Out.Int(v.Patch, 1); Out.String("; ");
    Out.String("preRelease="); Out.String(v.PreRelease); Out.String("; ");
    Out.String("build="); Out.String(v.Build); Out.String(";");
    Out.Ln;
  ELSE
    Out.String("Invalid version string."); Out.Ln;
  END;
END SemVerExample.
```

```
 $ voc ../src/SemVer.Mod -s SemVerExample.Mod -m 2>/dev/null && ./SemVerExample
../src/SemVer.Mod  Compiling SemVer.  New symbol file.  5302 chars.
SemVerExample.Mod  Compiling SemVerExample.  Main program.  1204 chars.
major=1; minor=2; patch=3; preRelease=alpha.1; build=build.5;
```



## Building

```
make
```

## Tests

```
make test
```

Includes various valid and invalid test cases to confirm compliance with
the SemVer 2.0.0 specification.

## Dependencies

- For Building: `voc` (duh!)
- Test runner: none

## TODO

- Compare
- Equals
- ToString
- ParseConstraint
- MatchConstraint
- IsStable
- IsPreRelease

## License

BSD 2-Clause License

