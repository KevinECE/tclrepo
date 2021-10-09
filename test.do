#################################################################################
# test.do --
#
#     Test script file for Modelsim. The script requires the argument 
#     "--test". If this argument is not provided, an error will be raised 
#     and printed out to the console; otherwise, the message "Hello!"
#     will be printed out to the console. In either case, after printing 
#     the relevant message, Modelsim will be closed.
#
#     For the script to be fully-functional, it is intended that it be 
#     executed either (1) via an already open `vsim` instance, e.g., 
#     via the command `do test.do`, or (2) via a call to the `vsim` 
#     command, e.g., `vsim -c -do "do test.do <args>"`.
#
# Author(s):
#     Christopher Crary (ccrary@ufl.edu)
#
# Last Modified By:
#     Christopher Crary
#
# Last Modified On:
#     October 4, 2021
#################################################################################

################################## DEPENDENCIES #################################

# The directory given to the following `lappend` command needs
# to contain the relevant `arc_misc.tcl` file. (Change if needed.)
quietly lappend auto_path "~/git/gp/code/scripts/tcl"
quietly package require arc::misc 1.0

############################## END OF DEPENDENCIES ##############################

################################### PROCEDURES ##################################
################################ END OF PROCEDURES ##############################

################################### SCRIPT BODY #################################

# NOTE: Within ModelSim, arguments must be accessed via the variables
# `1` - `9`, where the `shift` operator can be utilized to gain access
# to any more than nine arguments, or, as done below, to effectively handle
# each of any arguments passed into the script. Additionally, the `shift` 
# command does not overwrite the current value of a parameter (e.g., `$1`-`$9`)
# if there is no new value to shift into the parameter, so it is most effective
# to utilize the `argc` variable to parse through supplied parameters. (It is
# important to also note that the `shift` command decrements the `argc` variable
# by one.)

# Register all arguments to the script within a list,
# so that actual parsing of the arguments may be done
# in a more typical manner.
set args [list]

while {$argc > 0} {
    lappend args $1
    shift
}

# Define dictionary of acceptable script options.
# The dictionary key represents a script option name,
# and the value of a key represents the minimum
# and maximum number of arguments accepted by that
# script option.

quietly dict set opts --test {0 0}


# Define dictionary of acceptable script option shortcuts.
# These shortcuts are defined so that users can simply
# type shorter script option phrases when calling the script.

quietly dict set opts_shortcuts -t {--test}


# Define list of required script options.
# These are the script options that must be specified
# by a user when calling the script.

quietly set opts_required {--test}


# Parse relevant script arguments, expanding any shortcuts
# into fully qualified names whenever appropriate.
# (NOTE: The `parse_opts` subcommand of the arc::misc namespace
#  does *not* verify the semantics of a given script option,
#  only syntax. See the `arc_misc.tcl` file for more details.)
quietly set res [arc::misc parse_opts $args $opts $opts_shortcuts $opts_required]
lassign $res code message opts_specified

# Determine if there was an error during the argument parsing process.
if {$code == [arc::misc::ERR]} {
    # Error occurred; print relevant error and terminate script.
    puts $message
    return
}

# All script arguments met the specified syntax.

# For each specified script option, verify any relevant semantics
# related to the option (e.g., the type of argument(s) given to
# the option, if any), and, whenever appropriate, define
# variables to be utilized by the remainder of the script.

dict for {opt opt_args} $opts_specified {
    switch -exact -- $opt {

        # TEST (TODO: REMOVE)
        {--test} {
            # Test.
            puts "Hello!"
        }

    }
}

# Validation of relevant script option semantics is complete.

# Exit Modelsim.
exit

################################ END OF SCRIPT BODY #############################
