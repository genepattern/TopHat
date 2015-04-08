use strict;
use warnings;

while (my $line = <>) {
    next if ($line =~ /Process exited with status code:/);  # Local server executor appends this as final line

    # These are specifically for cuffcompare/cuffmerge which lack the --no-update-check option of the other cufflinks tools.
    next if ($line =~ /Warning.*Cufflinks is not up-to-date/);
    next if ($line =~ /You are using Cufflinks v2.0.2, which is the most recent release/);

    $line =~ s/\[[\d]{2}:[\d]{2}:[\d]{2}\]/\[timestamp\]/g;
    $line =~ s/(\/{0,1})Axis[0-9]+\.att\_/$1/g;
    $line =~ s/\/[A-Za-z\/0-9@._-]+\//\[system_path\]\//g;
    
    # These next two replacements are specifically for cuffmerge.
    # - First, replace UNIX timestamps.  Note that this is not particularly rigorous WRT month or day.
    $line =~ s/\[[A-Za-z]{3} [A-Za-z]{3}\s+\d{1,2} [\d]{2}:[\d]{2}:[\d]{2} \d{4}\]/\[timestamp\]/g;
    # - Next, deal with the names of some temp files generated during the run
    $line =~ s/_file[A-Za-z\d]{6} /_\[tempFile\] /g;
    
    print $line;
}
