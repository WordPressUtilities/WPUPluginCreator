<?php

$source_code = file_get_contents($argv[1]);

/* ----------------------------------------------------------
  Check modifiers
---------------------------------------------------------- */

/* Extract all variables
-------------------------- */

$vars = array_filter(
    token_get_all($source_code),
    function ($t) {return ($t[0] == T_VARIABLE || $t[0] == T_STRING);}
);

$variables = array();
foreach ($vars as $var) {
    if (!is_array($var)) {
        continue;
    }
    if (substr($var[1], 0, 1) != '$') {
        $var[1] = '$' . $var[1];
    }
    $variables[$var[1]] = $var[1];
}

/* Check if all variables have modifiers
-------------------------- */

$variables_without_modifiers = array();
$modifiers = array('private ', 'public ', 'protected ');
$modifiers_after = array(';', '=', ' ');
foreach ($variables as $var) {
    $var_name = str_replace('$', '', $var);
    $has_property = (strpos($source_code, '$this->' . $var_name . ' ') !== false);
    if (!$has_property) {
        continue;
    }
    $has_declaration = false;
    $tests = array();
    foreach ($modifiers_after as $modifier_after) {
        foreach ($modifiers as $modifier) {
            $modif_string = $modifier . $var . $modifier_after;
            if (strpos($source_code, $modif_string) !== false) {
                $has_declaration = true;
            } else {
                $tests[] = $modif_string;
            }
        }
    }
    if (!$has_declaration) {
        $variables_without_modifiers[] = $var;
    }
}

/* Add correct var declarations.
-------------------------- */

preg_match('/class ([A-Za-z_0-9]*) {/', $source_code, $match);
$string_modifiers = '';
if (isset($match[0])) {
    foreach ($variables_without_modifiers as $var) {
        $string_modifiers .= "\n    public {$var};";
    }
    $source_code = str_replace($match[0], $match[0] . $string_modifiers, $source_code);
    file_put_contents($argv[1], $source_code);
}

if ($string_modifiers) {
    echo "- Add correct variable declarations." . "\n";
} else {
    echo "- All variables seem correctly declared." . "\n";
}
