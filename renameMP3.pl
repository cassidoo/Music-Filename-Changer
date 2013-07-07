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

# I love pickles

MP3s();
MP4s();

sub stripUnwantedCrap
{
my $boog=shift;
    $boog =~ tr{\\\/}{-};
    $boog =~ tr{*?}{X};
    $boog =~ tr{“><[]|:;,’=\"}{_};
return $boog; 
}

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
	
	my $name = stripUnwantedCrap($tag->{NAM});
	my $art = stripUnwantedCrap($tag->{ART});
	my $alb = stripUnwantedCrap($tag->{ALB});
	
	my $title = $startdir . $name . " - " . $art . " - " . $alb;
	rename $file, "$title.m4a";
	print "renamed to: $title\n";
}

closedir(DIR);
}

