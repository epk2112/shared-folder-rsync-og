LOCAL='/cygdrive/c/Users/Docker/Downloads/Downloads_server/'
REMOTE='/cygdrive/c/Users/Docker/Desktop/bongoDir/'

if [[ -z "$LOCAL" || -z "$REMOTE" ]]; then
    echo 'No src/dst folder'
    exit
fi

while inotifywait -r -e modify,create,delete $LOCAL; do
    rsync -ahP --progress  $LOCAL $REMOTE
done