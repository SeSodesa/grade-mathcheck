
# MathCheck

A tool for checking math solutions in detail.
Developed by [Antti Valmari](http://users.jyu.fi/%7eava/indexEng.html).

## Motivation

MathCheck was originally designed to help students learn elementary university mathematics. The program made this possible by giving students immediate feedback on their solutions, a solution being the entire chain of reasoning given to the program by the student.

## MathCheck under the surface

MathCheck works by assigning many combinations of values to a set of variables given as a part of a problem and trying to find a counterexample to a given claim. A claim could be a chain of equalities, inequalities or logical equivalences between two or more logical [predicates](https://en.wikipedia.org/wiki/Predicate_%28mathematical_logic%29) $`P : X \to \{\mathrm T,\mathrm F,\mathrm U\}`$, where $`\lnot \mathrm T = \mathrm F`$, $`\lnot \mathrm F = \mathrm T`$ and $`\lnot \mathrm U = \mathrm U`$. MathCheck also includes a lightweight proof engine.

The program uses precise rational number arithmetic when it can, but resorts to floating point [interval arithmetic](https://en.wikipedia.org/wiki/Interval_arithmetic) when this is not possible. Rounding errors should therefore not cause any false alarms, but true alarms could be lost.

## Capabilities

The program has at least the following modes:

### Arithmetic
* comparing chains of equalities and inequalities,
* basic operators and functions and their derivatives.

### Tree comparison
* Expressing the structure of mathematical expressions

### Propositional logic
* Check a propositional chain of reasoning
* Can use 2- or 3-value logic, as per user desire

### Equation
* Same as arithmetic mode, but reports the loss of _teacher given_ solutions (roots) to the student.
* Checks whether student given solutions satisfy the equation being observed.
* Cannot tell if extra roots have been given.

### Modulo
* To put it simply, checks for modulo arithmetic.

### Array
* Allows the analysis of claims concerning arrays or matrices.


## MathCheck Authoring Tool Instructions

Version 2018-07-18, copied from http://math.tut.fi/mathcheck/cgi-bin/make_problem.out on 2019-05-30.

### Introduction

This program inputs MathCheck problem descriptions and produces the corresponding HTML problem pages. It has two modes, a web mode and batch mode. If you do not know which mode you are using, then you are using the web mode and can ignore the instructions on the batch mode.

A problem description consists of a sequence of commands of the form `#<command_name> <parameters>`. The most important commands are `#title`, `#question`, and `#hidden`. They specify the title of the problem page, the question(s) on the page, and the hidden information that MathCheck uses when checking the solution. In the batch mode, also `#filename` is important.

String Parameters contain text that will be shown to the student (perhaps after some processing), are intended for MathCheck, or both. MathCheck strings are string parameters that are intended for MathCheck. Although a lot of effort was made to make their use as simple and safe as possible, some tricky issues cannot be avoided. Therefore, please at least skim through these two sections. Variables allow (perhaps randomized) parameters in the problem pages. You can safely ignore that section, if you want.

These instructions are obtained by submitting an empty input in the web mode. For convenience, there may also be copies of the instructions as static web pages. They may be out of date. Therefore, if what you read does not seem to match with the reality, please switch to the automatic version. (Unfortunately, it, too, may be out of date, because after implementing a new feature or a modification to an old one, it has to be tested before it is reasonable to update the instructions.)

### Web Mode

In the web mode, the program produces a single web page. The generated page can be immediately used as such, or it can be saved with the save command of the web browser for (editing and) uploading to the teacher's site for future use.

The program makes some sanity checks on the input. The first error causes an error message on the produced web page, after which (in most cases) the program stops.

If the input specifies more than one MathCheck problem pages, the web mode presents them as a sequence on the single produced page. The batch mode splits them to many files.

### Batch Mode

The batch mode reads the standard input and produces zero or more HTML files that contain the problem pages. The names of the files are of the form `<name base><number>.html` (please see `#filename`). By default, the problems with the same `<name base>` are chained, that is, the feedback that MathCheck provides on a correct answer contains a link to the next problem.

The error messages from sanity checks go to the standard output.

To the extent that the input contains the answers (please see #answer), the batch mode also produces .mc files containing the hidden information and the answers. They can be used for testing both the problem and MathCheck.

### Commands

#### \#answer <MathCheck string>
If this command is given, it must be between a question and the generation of its answer box, and the string should be a correct answer. In the batch mode, it causes a `.mc` file be created that can be used for testing both the problem and MathCheck. In the web mode, #answer has no effect.

#### \#box_size \<rows\> \<cols\>
The parameters are positive integers specifying the height and width of the answer box. There are two levels of box sizes. Each `#filename` starts with a default box size. If `#box_size` is given soon enough after a #filename, it will be used as the global default. If given later, it remains valid until the next `#box_size` or #filename.

#### (\#confuse_off | \#confuse_on)
If confusion is on, the contents of the text areas generated by `#hidden` are not human-readable. However, the confusion is easily broken with a computer (and is thus not called encryption).

#### \#filename \<name base\>
The `<name base>` consists of a non-empty sequence of the following characters: `a … z`, `A … Z`, `_`. The generated files will have filenames of the form `<name base><number>.html`, where the number grows starting from 1 until the next `#filename`. In the batch mode, this command must occur at least once (before anything is written on the file). In the web mode, it is optional and has no effect.

#### \#hidden \<MathCheck string\>
This command generates a hidden text area with the string as its contents. This is where the teacher specifies the problem class and gives the information that MathCheck uses for checking the student's answer. If used, this command must be between a question and the generation of its answer box. 

#### \#html
After this command, the next string will be used as HTML markup instead of as text (except in the case of `#answer` and within `` ` ``-delimited segments). Please see String Parameters for more information. If you use this command, please run a HTML validator on the result. 

#### \#initial \<MathCheck string\>
This command causes the generation of a pending answer box and puts the string as its initial content. 

#### \#last_number \<number\>
The number of files in a chain can be given with this command. Doing so makes the page headers show it. After generating the files, the tool checks that the number is correct. The tool also uses this information to reason whether to print a chain continuation or chain ends command. 

#### \#let \<statements\>
The parameter is a (possibly empty) sequence of assignments and branch-statements. An assignment is of the form `<variable> := <expression>`. Please do not use branch-statements, because the design proved clumsy, so they will perhaps be moved to the level of `#`-commands. A branch-statement is of the form `branch <integer expression> <statements> next <statements> last <statements> end`, where the last-branch is optional and there may be zero or more next-branches. The value of the integer expression picks the branch that is executed. Negative values and `0` pick the first branch. If the value is bigger than the number of next-branches, the last-branch is chosen, if it is present. Please see Variables. 

#### \#MathCheck
This command generates a text paragraph with copyright information on this tool. 

#### \#no_chain
In batch mode, this command suppresses the chaining of problem pages and the showing of the file number in the title and header of the generated HTML files. The effect continues until next `#filename`. In the web mode, the chaining is not applied in any case, and #no_chain has no effect. 

#### \#no_focus
By default, when a problem page is opened, the focus is in the first answer box. If this command is written before the construction of the box, it switches this behaviour off for the current problem page. 

#### (\#Question \<string\> | \#question \<string\>)
The string will appear as the question text. Each `#question` generates a new answer box to the problem web page. Before generating it, the program continues reading the input for commands such as `#hidden` that are related to the question or the answer box. The answer box is automatically generated upon a command such as #text that relates to something else, or when the input ends. In particular, the next `#question` may be such a command. `#Question` differs in one respect: in the batch mode, if a previous file is still open, `#Question` does and `#question` does not first close it. These commands are not obligatory, but without them there will be no answer boxes.

#### \#random_seed <value>
This command sets the seed of the pseudorandom number generator. If this command is not used, the seed is picked from the starting time of the execution. The seed affects both the random parameters in the questions and the confusion feature.

#### (\#SUbmit | \#Submit | \#submit)
Submit buttons are usually generated automatically to the right place. With these commands, it is possible to force the generation at a certain place. `#SUbmit` generates both the submit same tab and submit new tab buttons. If the chaining of problem pages is on, it also generates a chaining command. If `last_number` has been given, it chooses between continuing and terminating the chain accordingly, and otherwise continues the chain. `#Submit` is otherwise similar, but terminates the chain if `last_number` has not been given. The choice between continuing and terminating the chain depends on user-given information, because the program cannot check the existence of a next file at this point of the input. `#submit` generates a submit new tab button without any chaining information, to facilitate submit buttons that only use a subset of the answer boxes on a problem page. 

#### \#suomi
Sets the `lang` attribute of the HTML pages to `fi`, for Finnish. By default, the attribute is for English. The HTML validator gives an error message if the attribute is too much in contradiction with the actual content of the HTML page. 

#### (\#Text <string> | \#text <string> | <string>)
These commands copy the string as a text paragraph. In batch mode, if a previous file is still open, `#Text` does and the other two do not first close it. When text goes to the end of the previous file although it was meant to go to the beginning of the next file, `#Text` can be used to fix the problem. 

#### \#title \<string\>
The string (perhaps extended with a number) will appear as the title and header of the produced web page(s). This command must occur at least once in the web mode, and at least once for each `#filename` in the batch mode. It must occur after the `#filename` and before any command that generates something on the problem page (such as `#question`). 

#### \#% \<string\>
This command has no effect. It facilitates writing comments in the input file. 

### String Parameters

A string may consist of any UTF-8 characters. (UTF-8 is a very comprehensive set of characters.) Please be careful with `#` and `` ` ``, because, as is explained below, they do not mean themselves.

A string may contain spaces and newlines. It terminates at an empty line, an instance of `#` other than those mentioned below, or the end of the input. (An empty line contains nothing or only spaces.) Redundant spaces at the beginning, end, and inside the string are removed, with the exception of spaces used for indenting lines. Also newlines at the beginning and end (but not inside) of the string are removed.

In the informal text, mathematical notation can be presented in AsciiMath that is preceded and succeeded by `` ` ``. Also allowing MathCheck notation is in future plans. A further future plan is to facilitate the use of MathCheck drawing commands. In the formal parts that go to MathCheck (that is, MathCheck strings), mathematical notation is expressed in MathCheck notation.

In web pages, `"`, `&`, `<`, and `>` have a special meaning. As a consequence, if they are written on a web page as such, they do not necessarily appear as themselves. By default, in .html (but not in .mc) files, this program replaces them by so-called character entities `&quot;`, `&amp;`, `&lt;`, and `&gt;`, which appear as ", &, <, and >. This means that as long as you do not want to write HTML markup, you need not worry about this issue.

To facilitate the use of HTML markup in problem pages, encoding as character entities is switched off by `#html`. However, `#html` affects neither `` ` ``-delimited segments nor the parameter of `#answer`, because they are not used as HTML markup. If the segment is started with `#` instead of `` ` ``, then encoding as character entities remains switched off. (This feature is probably unnecessary, but has been implemented to be on the safe side.) The segment may be ended with `` ` `` or `#` independently of which one started it. Also the contents of string variables are immune to #html, to make their use safer. (With integer variables, the issue does not arise.) The effect of #html switches off automatically after copying one string.

The sequences `#<newline>`, `#<space>`, `#"`, `##`, `#&`, `#<`, `#>`, and ``#` `` are converted to `<newline>`, `<space>`, `"`, `#`, `&`, `<`, `>`, and `` ` ``. This facilitates, for instance, forcing a space at the end of the parameter of `#initial`. One can also have `#` on the produced web page(s). The conversion causes ``#` `` to start an AsciiMath segment as described above, and gives an alternative to `#html` that is handy for small amounts of markup among big amounts of mathematics. It also makes it possible to have HTML markup in string variables. One should not use `#"`, `#&`, `#<`, and `#>` in the parameter of `#hidden`, because if something is forced correct with them in the .html file, then it becomes wrong in the `.mc` file.

For `#<letter>`, please see Variables.

### MathCheck Strings

Some commands take a string parameter that consists of MathCheck notation. Please see here for MathCheck notation, and please read String Parameters. One should not use `` ` `` and ``#` `` in MathCheck notation, to avoid confusion with AsciiMath.

To get `#`, please write `##`. If the program removes a space or newline that you want to stay, please try putting `#` to its front. The reasons for these are explained in String Parameters.

### Variables

Variables facilitate random values on problem pages and simplify writing identically repeating material. The names of integer variables are `a, …, z` and the names of string variables are `A, …, Z`. Their values are assigned with the `#let` command. A variable retains its value until assigned a new value, even if the problem page or file name base is changed in between.

In string parameters, each `#<variable>` is replaced by the value of the variable. The value is surrounded by white space, to avoid accidental fusion of two tokens into one like in sin h → sinh. The value of an integer variable is also surrounded by `(` and `)`, to ensure that the mathematical meaning is not affected by the environment. Other appearance may be obtained by first copying the value to a string variable.

Integer expressions may contain literals (non-empty sequences of digits), integer variables (without the `#` in front), parentheses `(` and `)`, unary `+` and `‐`, and binary `+`, `‐`, `*`, `/`, and `%`. They have their familiar meanings (% is modulo). Unary operators have the highest precedence, then `*`, `/`, and `%`, and finally binary `+` and `‐`. The binary operators associate to the left.

Integer expressions may also contain the following functions:

* `gcd(m,n)`

  * Returns the greatest common divisor of `m` and `n`. 

* `random(n)`

  * Returns a random value between $`0`$ and $`n-1`$. 

* `select(i, v0, …, vn)`

  * If $`i`$ is between $`0`$ and $`n`$ inclusive, select returns `vi`. If $`i < 0`$, select returns `v0`. If $`i > n`$, select returns `vn`. 

  * The implementation is not protected against arithmetic overflows. This means that arithmetic is unsafe above roughly $`2 \times 109`$.

  * A string expression consists of one or more string atoms separated by `+`. A string atom is either a string literal, an integer or string variable (without the `#` in front), or any of the following functions. The value of an integer variable is surrounded by `(` and `)`.

  * A string literal begins and ends with `"`. It can contain any characters, with the following exceptions. It cannot contain `` ` ``. It cannot contain `"` as such (but the same effect is obtained with `#%`). It cannot contain an empty line or a line that only contains spaces. It can contain no other instances of `#` than `#<newline>`, `#<space>`, `#"`, `##`, `#%`, `#&`, `#<`, and `#>`. Here `#%` denotes `"`, and the rest have the same meaning as in string parameters.

* (`Pterm(n,T)` | `pterm(n,T)`)

  * These return $`nT`$ formatted as a summand. If $`n = 0`$, these return the empty string. If $n = 1$, `Pterm` returns $`+T`$ and pterm returns $`T`$. If $`n = –1`$, these return $`-T`$. If $`n > 1`$, `Pterm` returns $+n T$ and `pterm` returns $`n T`$. If $`n < –1`$, these return $`n T`$ (where $`n`$ yields the minus sign). 

* `Pz(n)`

  * Returns n formatted as a summand. If $`n = 0`$, returns the empty string. If $`n > 0`$, returns $`+n`$. If $`n < 0`$, returns $`n`$ (including the minus sign). 

* `pZ(n)`

  * Returns `n` in the usual format. That is, the sign is printed only if it is `-`, and the value is printed even if it is `0`. 

* `select(i, V0, …, Vn)`

  * This function is similar to the integer function with the same name. Here the Vi and the return value are strings. 

