# arctan24

This is the implementation of the discrete arctangent used in Star Versus. It takes as input an X-delta, Y-delta, and quadrant number and returns a direction between 0 and 23. Documentation on parameter passing accompanies the function, of note, no registers are preserved. Assembly source uses ca65 syntax.

# testing

Using [nes_unit_testing](http://github.com/dustmop/nes_unit_testing), the lisp based unit test verifies a couple of inputs to the arctan function. Run the tests using:

```
./run_tests.sh
```

Assumes SBCL.

# more information

For more information on the motivation, design, and usage of this function, see this blog post.
