# tool marcros
CC := clang++# FILL: the compiler
CCFLAG := -std=c++17# FILL: compile flags
DBGFLAG := -g
CCOBJFLAG := $(CCFLAG) -c
TARFLAG := --target=x86_64-w64-mingw

# path marcros
BIN_PATH := bin
OBJ_PATH := obj
SRC_PATH := src
DBG_PATH := debug

# compile marcros
TARGET_NAME := main# FILL: target name
ifeq ($(OS),Windows_NT)
	TARGET_NAME := $(addsuffix .exe,$(TARGET_NAME))
endif
TARGET := $(BIN_PATH)/$(TARGET_NAME)
TARGET_DEBUG := $(DBG_PATH)/$(TARGET_NAME)
MAIN_SRC := src/main.cpp# FILL: src file contains `main()`

# src files & obj files
SRC := $(foreach x, $(SRC_PATH), $(wildcard $(addprefix $(x)/*,.c*)))
OBJ := $(addprefix $(OBJ_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))
OBJ_DEBUG := $(addprefix $(DBG_PATH)/, $(addsuffix .o, $(notdir $(basename $(SRC)))))

# clean files list
DISTCLEAN_LIST := $(OBJ) \
                  $(OBJ_DEBUG)
CLEAN_LIST := $(TARGET) \
			  $(TARGET_DEBUG) \
			  $(DISTCLEAN_LIST)

# default rule
default: all

OPENGL_PATH := openGL
OPENGL_INCLUD := $(OPENGL_PATH)/include
OPENGL_LIBS := $(OPENGL_PATH)/libs
LINKLIBS := -lassimp.dll -lstbimage -lglfw3dll -lglfw3 -lglad

# non-phony targets
$(TARGET): $(OBJ)
	$(CC) $(TARFLAG) $(CCFLAG) -o $@ $(OBJ) -I$(OPENGL_INCLUD) -L$(OPENGL_LIBS) $(LINKLIBS)

$(OBJ_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(TARFLAG) $(CCOBJFLAG) -o $@ $< -I$(OPENGL_INCLUD)

$(DBG_PATH)/%.o: $(SRC_PATH)/%.c*
	$(CC) $(TARFLAG) $(CCOBJFLAG) $(DBGFLAG) -o $@ $< -I$(OPENGL_INCLUD)

$(TARGET_DEBUG): $(OBJ_DEBUG)
	$(CC) $(TARFLAG) $(CCFLAG) $(DBGFLAG) $(OBJ_DEBUG) -o $@ -I$(OPENGL_INCLUD) -L$(OPENGL_LIBS) $(LINKLIBS)

# phony rules
.PHONY: all
all: $(TARGET)

.PHONY: debug
debug: $(TARGET_DEBUG)

.PHONY: clean
clean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(CLEAN_LIST)

.PHONY: distclean
distclean:
	@echo CLEAN $(CLEAN_LIST)
	@rm -f $(DISTCLEAN_LIST)