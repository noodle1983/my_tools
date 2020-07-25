#!/bin/bash
useradd -m -s /bin/bash $1
passwd $1 <<END_OF_PW
$1
$1
END_OF_PW
