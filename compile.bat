@echo off
echo "Compiling files, wait please..."
ozc -c Environment.oz
ozc -c Main.oz
ozc -c Operator.oz
ozc -c Tree.oz
ozc -c StringEder.oz
ozc -c programs/square/SquareTest.oz
ozc -c programs/arithmetic/ArithmeticTest.oz
ozc -c programs/div/DivTest.oz
ozc -c programs/fourtimes/FourtimesTest.oz
ozc -c programs/fourtimes_callback/FourtimesCallbackTest.oz
ozc -c programs/id/IdTest.oz
ozc -c programs/sqr/SqrTest.oz
ozc -c programs/square_callback/SquareCallbackTest.oz
ozc -c programs/sum_n/SumNTest.oz
ozc -c programs/sum_n_callback/SumNCallbackTest.oz
ozc -c programs/sum_sub/SumSubTest.oz
ozc -c programs/twice/TwiceTest.oz
ozc -c programs/twice_callback/TwiceCallbackTest.oz
ozc -c programs/var_use/VarUseTest.oz