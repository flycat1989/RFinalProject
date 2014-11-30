use WWW::Mechanize;
use HTML::TableExtract;


sub getHTML {
$url_id=@_[0];
$doc_id=@_[1];
$state_id=@_[2];

$group1_id=$doc_id.".V9-level2";
$group2_id=$doc_id.".V1";
$field_id="F_".$doc_id.".V9";

my $mech = WWW::Mechanize->new();
$url="http://wonder.cdc.gov/".$url_id.".html";

$mech->get( $url );
$mech->click_button( name => "action-I Agree");

$mech->set_fields("B_1"=>$group1_id,
		"B_2"=>$group2_id,
		$field_id=>$state_id,
	);

$mech->click_button( name=>"action-Send");
$htmlResult=$mech->content();

$te=new HTML::TableExtract(depth=>1, count=>4);
$te->parse($htmlResult);

open (WRITE_TABLE, ">", "MortalityData/$url_id-$state_id.txt");
foreach $row ($te->rows) {
   print WRITE_TABLE join("\t", @$row), "\n";
}
close(WRITE_TABLE);

# open (WRITE_HTML, ">", "MortalityData/$url_id-$state_id.html");
# print WRITE_HTML $htmlResult;
# close(WRITE_HTML);

}

@url_list=("cmf-icd8","cmf-icd9","cmf-icd10");
@doc_list=("D74","D16","D103");


@state_list=("01","02"    ,"04","05","06"    ,"08","09","10","11","12","13"    ,"15",
		"16","17","18","19","20","21","22","23","24","25","26","27","28","29","30",
		"31","32","33","34","35","36","37","38","39","40","41","42"    ,"44","45",
		"46","47","48","49","50","51"   ,"53","54","55","56");
for $url_doc_ptr (0..2){
	foreach $state_ptr (@state_list){
		print "Now processing $url_list[$url_doc_ptr]-$state_ptr ...\n";		
		$filename = "MortalityData/$url_list[$url_doc_ptr]-$state_ptr.txt";
 		if (-e $filename) {
 				print "File Exists! Moving to the next file\n";
		 }else{ 
			getHTML($url_list[$url_doc_ptr],$doc_list[$url_doc_ptr],$state_ptr);
		}
	}
}


