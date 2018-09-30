EXT_DIR=external

F4SE_REPO=https://github.com/osvein/f4se-mirror.git
F4SE_TAG=v0.6.12
F4SE_DIR=$(EXT_DIR)/f4se
F4SE_INC=$(F4SE_DIR)/src/f4se $(F4SE_DIR)/src
GITFLAGS=-c advice.detachedHead=false

F4SE_SRC_DIR=$(F4SE_DIR)/src/f4se/f4se_common
F4SE_SRCS=$(shell find $(F4SE_SRC_DIR) -name '*.cpp')
# FIXME: If these files don't exist (eg: after dist-clean) F4SE_LIB will be an empty archive
F4SE_OBJS=$(subst .cpp,.o,$(F4SE_SRCS))
F4SE_LIB=f4se_common.a
F4SE_TARGET=$(F4SE_LIB)

DEPENDS=$(F4SE_DIR)

SRC_DIR=.
SRCS=$(shell find $(SRC_DIR) -name '*.cpp' -not -path './$(EXT_DIR)/*')
OBJS=$(subst .cpp,.o,$(SRCS))
INCLUDE=$(SRC_INC) $(F4SE_INC)
CPPFLAGS=$(foreach d, $(INCLUDE), -I$d) -m64 -include common/IPrefix.h -Wno-literal-suffix '-D__except(x)=__catch(...)'
LDFLAGS=-shared $(F4SE_TARGET)

DUMMY_SRCS=dummy-app.cxx
DUMMY_TARGET=dummy-app.exe

TARGET=pluginAlpha.dll

INSTALL_PATH="C:\Program Files (x86)\Steam\SteamApps\common\Fallout 4\Data\F4SE\Plugins\$(TARGET)"

AR=x86_64-w64-mingw32-gcc-ar
CPP=x86_64-w64-mingw32-g++
GIT=git
LD=x86_64-w64-mingw32-g++

.PHONY: clean default depend dist-clean dummy-app f4se_clean f4se_tidy fallout install

default: all

all: install

$(F4SE_DIR):
	$(GIT) $(GITFLAGS) clone $(F4SE_REPO) -b $(F4SE_TAG) $@

depend: $(DEPENDS)

dummy-app: $(DUMMY_TARGET)

$(DUMMY_TARGET): $(DUMMY_SRCS) $(TARGET)
	$(CPP) $(CPPFLAGS) $(DUMMY_SRCS) $(TARGET) -o $@

%.o: %.cpp $(DEPENDS)
	$(CPP) $(CPPFLAGS) -c $< -o $@

$(TARGET): $(OBJS) $(F4SE_TARGET)
	$(LD) $< $(LDFLAGS) -o $@

$(F4SE_TARGET): $(F4SE_OBJS)
	$(AR) rcs $@ $^

f4se_tidy:
	rm -f $(F4SE_OBJS)

f4se_clean: f4se_tidy
	rm -f $(F4SE_TARGET)

# FIXME: Do not copy if the plugin isn't newer
install: $(TARGET)
	cp $(TARGET) $(INSTALL_PATH)

fallout: install
	cd "C:\Program Files (x86)\Steam\SteamApps\common\Fallout 4" ; ./f4se_loader.exe

tidy:
	rm -f $(OBJS)

clean: tidy
	rm -rf $(TARGET)

dist-clean: clean f4se_clean
	rm -rf $(EXT_DIR)