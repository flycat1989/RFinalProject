use WWW::Mechanize;
use HTML::TableExtract;


sub getHTML {
$state_id=@_[0];
$year_id=@_[1];

my $mech = WWW::Mechanize->new();
$url="http://wonder.cdc.gov/nasa-nldas.html";

$mech->get( $url );
$mech->tick("M_3"=>"D60a.M3");
$mech->set_fields("B_1"=>"D60a.V2-level2",
		"B_2"=>"D60a.V4",
		
		"F_D60a.V2"=>$state_id,


		"F_D60a.V7"=>$year_id,
		
	);

$mech->click_button( name=>"action-Send");
$htmlResult=$mech->content();

$te=new HTML::TableExtract(depth=>1, count=>4);
$te->parse($htmlResult);

open (WRITE_TABLE, ">", "ClimateData/$state_id-$year_id.txt");
foreach $row ($te->rows) {
   print WRITE_TABLE join("\t", @$row), "\n";
}
close(WRITE_TABLE);

# open (WRITE_HTML, ">", "MortalityData/$url_id-$state_id.html");
# print WRITE_HTML $htmlResult;
# close(WRITE_HTML);

}

@year_list=("1979","1980","1981","1982","1983","1984",
"1985","1986","1987","1988","1989","1990",
"1991","1992","1993","1994","1995","1996",
"1997","1998","1999","2000","2001","2002",
"2003","2004","2005","2006","2007","2008",
"2009","2010","2011");


@state_list=("01"    ,"04","05","06"    ,"08","09","10","11","12","13"    ,"15",
		"16","17","18","19","20","21","22","23","24","25","26","27","28","29","30",
		"31","32","33","34","35","36","37","38","39","40","41","42"    ,"44","45",
		"46","47","48","49","50","51"   ,"53","54","55","56");
foreach $state_ptr (@state_list){
	foreach $year_ptr (@year_list){
		print "Now processing $state_ptr-$year_ptr ...\n";		
		$filename = "ClimateData/$state_ptr-$year_ptr.txt";
 		if (-e $filename) {
 			print "File Exists! Moving to the next file\n";
		 }else{ 
			getHTML($state_ptr,$year_ptr);
		}
	}
}


