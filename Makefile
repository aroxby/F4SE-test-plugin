EXT_DIR=external

F4SE_REPO=https://github.com/osvein/f4se-mirror.git
F4SE_TAG=v0.6.12
F4SE_DIR=$(EXT_DIR)/f4se
F4SE_INC=$(F4SE_DIR)/src/f4se
GITFLAGS=-c advice.detachedHead=false

DEPENDS=$(F4SE_DIR)

SRC_DIR=.
SRCS=$(shell find $(SRC_DIR) -name '*.cpp' -not -path './$(EXT_DIR)/*')
OBJS=$(subst .cpp,.o,$(SRCS))
INCLUDE=$(SRC_INC) $(F4SE_INC)
CPPFLAGS=$(foreach d, $(INCLUDE), -I$d) -m64
LDFLAGS=-shared

DUMMY_SRCS=dummy-app.cxx
DUMMY_TARGET=dummy-app.exe

TARGET=pluginAlpha.dll

INSTALL_PATH="C:\Program Files (x86)\Steam\SteamApps\common\Fallout 4\Data\F4SE\Plugins\$(TARGET)"

GIT=git
CPP=x86_64-w64-mingw32-g++
LD=x86_64-w64-mingw32-g++

.PHONY: default depend clean dist-clean dummy-app install

default: all

all: install

$(F4SE_DIR):
	$(GIT) $(GITFLAGS) clone $(F4SE_REPO) -b $(F4SE_TAG) $@

depend: $(DEPENDS)

dummy-app: depend $(DUMMY_SRCS) $(TARGET)
	$(CPP) $(CPPFLAGS) $(DUMMY_SRCS) $(TARGET) -o $(DUMMY_TARGET)

%.o: %.cpp depend
	$(CPP) $(CPPFLAGS) -c $< -o $@

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) $< -o $@

install: $(TARGET)
	cp $(TARGET) $(INSTALL_PATH)

tidy:
	rm -f $(OBJS)

clean: tidy
	rm -rf $(TARGET)

dist-clean: clean
	rm -rf $(EXT_DIR)