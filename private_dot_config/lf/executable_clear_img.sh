# #!/bin/sh
# if [ -n "$FIFO_UEBERZUG" ]; then
# 	printf '{"action": "remove", "identifier": "preview"}\n' >"$FIFO_UEBERZUG"
# fi

#!/bin/sh

ueberzugpp cmd -s $UB_SOCKET -a remove -i PREVIEW
