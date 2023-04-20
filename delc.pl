#!/usr/bin/perl -w
#Author: Justin Moore
#Date: 2023-04-20
#Description: This perl script is used to walk through
#your present working directory and mark files or dirs for
#deletion one by one. Then deletes the files and/or dirs


#rmtree - remove whole directory trees like rm -r
use File::Path qw(rmtree);

#remove files the user has selected
sub remove_files
{

	print "\nremoving file(s) AND dir(s) now...\n\n";

	foreach $del_file(@deletion_files)
	{
		if(-f $del_file)		#if it's a file then delete it
		{
			unlink($del_file);
		}
		else
		{
			rmtree($del_file);	#if it's a dir then recursively delete it 
		}				#and its contents
	}

}


#confirm that the user wants to proceed with deletion of files and dirs
sub deletion_confirmation
{
	print "\nfile list ready for deletion:\n";

	if(@deletion_files == 0)				#empty list
	{
		print "list is empty, exiting program...\n";
		exit 0;
	}

	foreach $del_file(@deletion_files)			#display list of chosen files
	{
		print "$del_file\n";
	}



	print "\ncomplete all deletions? [Y]: ";
	$input = <STDIN>;
	chop $input;

	if($input eq "y" || "Y")				#if yes then remove files
	{
		print "you entered yes...\n";
		&remove_files;
	}
	else							#otherwise quit program
	{
		print "Nothing has been deleted...\n";
		exit 0;
	}
}



#this subroutine will allow the user to 
#walk through each file or directory in the
#present working directory
sub traverse_current_directory
{
	if (@ARGV)							#save arguments to buffer for processing
	{ 
		@file_list = @ARGV;
	}
	else								#if there are no arguments then print usage/quit
	{ 
		print "no args...\n";
		exit 1;
	}


	my $size_of_file_list = @file_list;	
	$counter = 0;
	
	
						
	foreach $file(@file_list)					#iterate over each element in list
	{
		
		
		if(-f $file)
		{
			print "delete?[y,n,q] file: $file\n";
		}
		elsif(-d $file)
		{
			print "delete?[y,n,q] dir: $file\n";
		}
		else
		{
			print "could not find your file(s) or dir(s)...\n";
			exit 0;
		}

		$input = <STDIN>;
		chop $input;
		
		if($input eq "y")
		{
			push(@deletion_files, $file); 			#add file to list for deletion
			
			
		}
		elsif($input eq "n")					#if no then skip file
		{
			next;
		}
		elsif($input eq "q")					#if quit then go to confirmation
		{
			&deletion_confirmation;
			exit 0;
		}
		else							#for all other input that is not valid
		{
			print "did not recognize input...\n";
			exit 1;
		}
		
		$counter++;
		
		if($size_of_file_list == $counter)			#checking size of array against the current count
		{
			&deletion_confirmation;
		}
		
		
	}

}



&traverse_current_directory;						#making intial call to start program



























































 




