#!/bin/sh
sbcl --noinform --non-interactive \
    --eval "(require :cl-6502)" \
    --load "nes_unit_testing.lisp" \
    --eval "(nes-unit-testing::all-tests-in-current-directory)"
