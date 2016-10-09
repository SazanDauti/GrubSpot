<?php

require('conn.php');

function midPoint($lat1, $lon1, $lat2, $lon2){
    $dLon = deg2rad($lon2 - $lon1);

    $lat1 = deg2rad($lat1);
    $lat2 = deg2rad($lat2);
    $lon1 = deg2rad($lon1);

    $Bx = cos($lat2) * cos($dLon);
    $By = cos($lat2) * sin($dLon);
        $lat3 = atan2(sin($lat1) + sin($lat2), sqrt((cos($lat1) + $Bx) * (cos($lat1) + $Bx) + $By * $By));
    $lon3 = $lon1 + atan2($By, cos($lat1) + $Bx);

    $resultlat = rad2deg($lat3);
    $resultlon = rad2deg($lon3);
    return array($resultlat, $resultlon);

}

function getSteps($json, $db, $cat) {
    $mainArr = array();
    $info = json_decode($json, true);
    
    $steps = $info['routes'][0]['legs'][0]['steps'];
    
    foreach ($steps as $step) {
        
        $instructions = $step['html_instructions'];
        
        preg_match("/(on|onto) <b>(.*?)<\/b>/", $instructions, $matches);
        
        $street_name = $matches[2];
        
        $start_lat = $step['start_location']['lat'];
        $start_lng = $step['start_location']['lng'];
        
        $end_lat = $step['end_location']['lat'];
        $end_lng = $step['end_location']['lng'];
        
        $distance = $step['distance']['value']/2000;
        
        $mid = midPoint($start_lat, $start_lng, $end_lat, $end_lng);
        $fLat = $mid[0];
        $fLon = $mid[1];
        
        if (trim($street_name) != "") {
            
            if (trim($cat) == "") {
                $SQL = "SELECT *, ACOS( SIN( RADIANS( `latitude` ) ) * SIN( RADIANS( $fLat ) ) + COS( RADIANS( `latitude` ) ) * COS( RADIANS( $fLat )) * COS( RADIANS( `longitude` ) - RADIANS( $fLon )) ) * 6380 AS `distance` FROM `businesses` WHERE ACOS( SIN( RADIANS( `latitude` ) ) * SIN( RADIANS( $fLat ) ) + COS( RADIANS( `latitude` ) ) * COS( RADIANS( $fLat )) * COS( RADIANS( `longitude` ) - RADIANS( $fLon )) ) * 6380 < $distance ORDER BY `rating`";
            } else {
               $SQL = "SELECT *, ACOS( SIN( RADIANS( `latitude` ) ) * SIN( RADIANS( $fLat ) ) + COS( RADIANS( `latitude` ) ) * COS( RADIANS( $fLat )) * COS( RADIANS( `longitude` ) - RADIANS( $fLon )) ) * 6380 AS `distance` FROM `businesses` WHERE ACOS( SIN( RADIANS( `latitude` ) ) * SIN( RADIANS( $fLat ) ) + COS( RADIANS( `latitude` ) ) * COS( RADIANS( $fLat )) * COS( RADIANS( `longitude` ) - RADIANS( $fLon )) ) * 6380 < $distance AND `type` LIKE '%$cat%' ORDER BY `rating`";
            }
        
            $grab = $db->query($SQL);
            
            $res = $grab->fetchAll(PDO::FETCH_ASSOC);
            foreach($res as $rest) {
                $street_addr = $rest['street'];
                $street_addr = trim(preg_replace("/[0-9]/", "", $street_addr));
                $clean_comp_addr = trim(preg_replace("/[0-9]/", "", $street_name));
                if (strpos($clean_comp_addr, ",") !== FALSE) {
                    $clean_comp_addr = substr($clean_comp_addr, 0, strpos($clean_comp_addr, ","));
                }
                $toDiv = 0;
                if (strlen($clean_comp_addr) > strlen($street_addr)) {
                    $toDiv = strlen($street_addr)/2;
                } else {
                    $toDiv = strlen($clean_comp_addr)/2;
                }
                if (strtolower(substr($clean_comp_addr, 0, $toDiv)) == strtolower(substr($street_addr, 0, $toDiv))) {
                    //RESTAURANT IS GOOD
                    array_push($mainArr, $rest);
                }
            }
            
            //$temp = array("lat"=>$mid[0], "lng"=>$mid[1], "distance"=>$distance, "street_name"=>$street_name);
            
            //echo $start_lat . " , " . $start_lng . "<br />" . $end_lat . " , " . $end_lng;
            
           // echo "<br />-------<br />";
            
        }
     
        
        
    }
    return $mainArr;
}


$api_key = "AIzaSyA6t8RfoLkkmIRJqKMiQ4KVgcLcQEFWZuM";
/*
$start = "75+9th+Ave+New+York,+NY";
$end = "MetLife+Stadium+1+MetLife+Stadium+Dr+East+Rutherford,+NJ+07073";
$start = $_GET['start'];
$end = $_GET['end'];
*/
$start = $_GET['start'];
$end = $_GET['end'];
/*
$start = "140+Commonwealth+ave,+Boston,+MA";
$end = "201+Brookline+Ave,+Boston,+MA+02215";
*/

$cat = $_GET['cat'];

$url = "https://maps.googleapis.com/maps/api/directions/json?origin=" . $start . "&destination=" . $end . "&key=" . $api_key;

$json = file_get_contents($url);

$steps = getSteps($json, $db, $cat);

echo json_encode($steps);

?>