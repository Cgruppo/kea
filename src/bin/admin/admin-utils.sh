# Copyright (C) 2014 Internet Systems Consortium, Inc. ("ISC")
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND ISC DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS.  IN NO EVENT SHALL ISC BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
# OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

# This is an utility script that is being included by other scripts.

# There are two ways of calling this method.
# mysql_execute SQL_QUERY - This call is simpler, but requires db_user,
#     db_password and db_name variables to be bet.
# mysql_execute SQL_QUERY PARAM1 PARAM2 .. PARAMN - Additional parameters
#     may be specified. They are passed directly to mysql. This one is
#     more convenient to use if the script didn't parse db_user db_password
#     and db_name.
#
# @todo: Catch mysql return code. I tried to use PIPESTATUS[X], but it doesn't
# seem to work (or at least I don't know how to use it).
mysql_execute() {
    if [ $# -gt 1 ]; then
        QUERY=$1
        shift
        _RESULT=`echo $QUERY | mysql -N -B $@`
    else
        _RESULT=$(mysql -N -B --user=$db_user --password=$db_password -e "${1}" $db_name)
    fi
}

mysql_version() {
    mysql_execute "SELECT CONCAT(version,\".\",minor) FROM schema_version" "$@"
}

mysql_version_print() {
    mysql_version "$@"
    printf "%s" $_RESULT
}
