.POSIX:

SRC        = ../src
TESTS      = ../tests
BUILD      = build

OBJS       = $(BUILD)/SemVer.o
SEMVERTEST = $(BUILD)/SemVerTest

all: build

build:
	mkdir -p $(BUILD)
	cd $(BUILD) && voc $(SRC)/SemVer.Mod -s 2>/dev/null

test: $(SEMVERTEST)
	cd $(BUILD) \
	&& ./SemVerTest

$(SEMVERTEST): build
	cd $(BUILD) \
	&& voc $(TESTS)/SemVerTest.Mod -m 2>/dev/null

clean:
	rm -rf $(BUILD)
