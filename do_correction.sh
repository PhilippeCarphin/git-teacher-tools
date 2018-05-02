#!/bin/bash

tmux_session=$PWD/tmux-session.tmux

testing=false

if [[ $testing == true ]] ; then
    pushd ./correction_tp8/section-02
    pushd 2532
    tmux new-session \; source-file $tmux_session
    popd
    popd
    exit 0
fi

for d in ./correction_tp8/section-02 ./correction_tp8/section-06 ; do
    if [ -e $d/done.m ] ; then
        continue
    fi
    pushd $d
        for g in $(ls) ; do
            if [ -e $g/done.m ] ; then
                continue
            fi
            pushd $g
                tmux new-session \; source-file $tmux_session
            popd
            if [ -e stop.m ] ; then
                exit 0
            fi
        done
    popd
done
