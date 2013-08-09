use warnings;
use strict;

use MP3::Info;
use MP4::Info;
use Cwd;
 
my $startdir = $ARGV[0] || getcwd;
 
if (!-d $startdir)
{
	die "$startdir is not a directory";
}

# Call functions for both MP3s and MP4s

MP3s();
MP4s();

#Stripping unwanted characters
sub stripUnwanted
{
my $b=shift;
    $b =~ tr{\\\/}{-};
    $b =~ tr{*?}{X};
    $b =~ tr{“><[]|:;,’=\"}{_};
return $b; 
}

#Handles MP3 files.  Opens the directory, gets all the files, renames each one to title - artist - album
sub MP3s {
opendir(DIR, $startdir);
my @files = grep(/\.mp3$/,readdir(DIR));

my $file;
if(!($startdir =~ /\/$/))
{
	$startdir .= '/';
}

foreach $file (@files)
{
	my $tag = get_mp3tag($file) or next;
	my $title = $startdir . $tag->{TITLE} . " - " . $tag->{ARTIST} . " - " . $tag->{ALBUM};
	rename $file, "$title.mp3";
	print "renamed to: $title\n";
}

closedir(DIR);
}

#Handles MP4 files.  Opens the directory, gets all the files, renames each one to title - artist - album.
#Unwanted parts of the names have to be stripped here.
sub MP4s {
opendir(DIR, $startdir);
my @files = grep(/\.m4a$/,readdir(DIR));

my $file;
if(!($startdir =~ /\/$/))
{
	$startdir .= '/';
}

foreach $file (@files)
{
	my $tag = get_mp4tag($file) or next;
	
	my $name = stripUnwanted($tag->{NAM});
	my $art = stripUnwanted($tag->{ART});
	my $alb = stripUnwanted($tag->{ALB});
	
	my $title = $startdir . $name . " - " . $art . " - " . $alb;
	rename $file, "$title.m4a";
	print "renamed to: $title\n";
}

closedir(DIR);
}

