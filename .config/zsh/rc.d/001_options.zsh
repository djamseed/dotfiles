# Enable useful shell options:
#  - ALWAYS_TO_END - move cursor to the end of a completed word
#  - AUTO_CD - change directory without no need to type 'cd' when changing directory
#  - AUTO_MENU - enable autocompletion menu
#  - AUTO_RESUME - attempt to resume existing job before creating a new process
#  - COMPLETE_IN_WORD - complete words at the cursor position
#  - CORRECT_ALL - suggest corrections for mistyped commands
#  - EXTENDED_GLOB - treat '#', '~' and '^' chars as part of patterns for filename generation
#  - HASH_LIST_ALL - whenever a command completion is attempted, make sure the entire command path is hashed first
#  - MENU_COMPLETE - cycle through completion with TAB
#  - NO_BEEB - remove the annoying beep sound
#  - NO_CASE_GLOB - case-insensitive globbing
#  - NO_CASE_MATCH - case-insensitive matching for completion
#  - NO_CLOBBER - prevent file overwrite on stdout redirection
# -  NO_NO_MATCH - try to avoid the 'zsh: no matches found...
#  - NO_RM_STAR_SILENT - prevent accidental 'rm *' disasters
#  - NULL_GLOB - Delete pattern in argument list if no match found

setopt \
    ALWAYS_TO_END \
    AUTO_CD \
    AUTO_MENU \
    AUTO_RESUME \
    COMPLETE_IN_WORD \
    CORRECT_ALL \
    EXTENDED_GLOB \
    HASH_LIST_ALL \
    MENU_COMPLETE \
    NO_BEEP \
    NO_CASE_GLOB \
    NO_CLOBBER \
    NO_CASE_MATCH \
    NO_NO_MATCH \
    NO_RM_STAR_SILENT \
    NULL_GLOB
