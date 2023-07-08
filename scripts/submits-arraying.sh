#! /bin/sh

for i in \
    6 7 8 12 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 34 35 36 37 42 43 45 46 47 48 49 50 51 52 53 54 55 \
    56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90
do
    path=$(printf "solutions/arraying_%03d.json" $i)
    submit=${path}.submit
    if [ -r ${submit} ]; then
        echo "alreay submitted, skip $path"
    else
        set -x
        ( ./api-sh/submit.sh $i $path ; /bin/echo ) > ${submit}
        set +x
    fi
done
