#!/bin/sh

echo "Starting '$0'..."

# This script is based fairly heavily off bateau84/openttd's. Thanks, man!
savepath="/config/save"
savegame="${savepath}/${savename}"

if [ ! -f /config/openttd.cfg ]; then
        # we start the server then kill it quickly to write a config file
        # yes this is a horrific hack but whatever
        echo "No config file found: generating one"
        timeout -t 3 /usr/local/bin/openttd -D > /dev/null 2>&1
fi

if [ "${loadgame}x" != "x" ]; then

        case ${loadgame} in
                'true')
                        if [ -f  ${savegame} ]; then
                                echo "Loading ${savegame}"
                                exec /usr/local/bin/openttd -D -g ${savegame} -x -d ${DEBUG}
                                exit 0
                        else
                                echo "${savegame} not found..."
                                exit 0
                        fi
                ;;
                'false')
                        echo "Creating a new game."
                        exec /usr/local/bin/openttd -D -x -d ${DEBUG}
                        exit 0
                ;;
                'last-autosave')

	    latest_savegame="$(ls -1t ${savepath}/autosave/ | head -n1)"
	    savegame="${savepath}/autosave/${latest_savegame}"

	    echo "Latest autosave found : ${latest_savegame} at $(stat -c '%y' ${savegame})"


            if [ -r ${savegame} ]; then
                            echo "Loading from autosave - ${savegame}"
                            exec /usr/local/bin/openttd -D -g ${savegame} -x -d ${DEBUG}
                            exit 0
            else
                echo "${savegame} not found"
                exit 1
            fi
                ;;
                'exit')

            savegame="${savepath}/autosave/exit.sav"

            if [ -r ${savegame} ]; then
                            echo "Loading from exit save"
                            exec /usr/local/bin/openttd -D -g ${savegame} -x -d ${DEBUG}
                            exit 0
            else
                echo "${savegame} not found"
                exit 1
            fi
                ;;
        *)
            echo "ambigous loadgame (\"${loadgame}\") statement"
            exit 1
        ;;
        esac
else
    echo "loadgame not set - starting new game"
        exec /usr/local/bin/openttd -D -x
        exit 0
fi
