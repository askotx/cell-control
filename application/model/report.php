<?php

class Report{
    
    function __construct($db){
        try {
            $this->db = $db;
        }
        catch (PDOException $e) {
            exit('Database connection could not be established.');
        }
    }

    public function getReports($page, $rows, $sort_idx, $sort_dir, $filter=''){
        $pager = new Pager($this->db, 1, $page, $rows, $sort_idx, $sort_dir, $filter);
        return $pager->createData();
    }
    
    public function getReport($report_id){
        $sql = "CALL getReport(:reportId)";
        
        $query = $this->db->prepare($sql);
        $query->bindValue(":reportId", $report_id, PDO::PARAM_INT);
        $query->execute();
        
        return $query->fetchObject();
    }

    public function getReportsOfCellphones($report_id){
        $sql = "CALL getCellphonesReport(:reportId)";
        
        $query = $this->db->prepare($sql);
        $query->bindValue(":reportId", $report_id, PDO::PARAM_INT);
        $query->execute();
        
        return $query->fetchAll();
    }
    
    public function getContactsByTerm($term, $user_type){
        $sql = "CALL getContactsByTerm(:term, :user_type)";
        $params = array(':term' => $term, ':user_type' => $user_type);
        
        $query = $this->db->prepare($sql);
        $query->execute($params);
        return $query->fetchAll();
    }

    /*public function addReport($artist, $track, $link){
        $sql = "INSERT INTO song (artist, track, link) VALUES (:artist, :track, :link)";
        $query = $this->db->prepare($sql);
        $parameters = array(':artist' => $artist, ':track' => $track, ':link' => $link);

        $query->execute($parameters);
    }

    public function getReport($song_id){
        $sql = "SELECT id, artist, track, link FROM song WHERE id = :song_id LIMIT 1";
        $query = $this->db->prepare($sql);
        $parameters = array(':song_id' => $song_id);

        // useful for debugging: you can see the SQL behind above construction by using:
        // echo '[ PDO DEBUG ]: ' . Helper::debugPDO($sql, $parameters);  exit();

        $query->execute($parameters);

        // fetch() is the PDO method that get exactly one result
        return $query->fetch();
    }

    public function updateSong($artist, $track, $link, $song_id){
        $sql = "UPDATE song SET artist = :artist, track = :track, link = :link WHERE id = :song_id";
        $query = $this->db->prepare($sql);
        $parameters = array(':artist' => $artist, ':track' => $track, ':link' => $link, ':song_id' => $song_id);

        // useful for debugging: you can see the SQL behind above construction by using:
        // echo '[ PDO DEBUG ]: ' . Helper::debugPDO($sql, $parameters);  exit();

        $query->execute($parameters);
    }

    public function getAmountOfSongs()
    {
        $sql = "SELECT COUNT(id) AS amount_of_songs FROM song";
        $query = $this->db->prepare($sql);
        $query->execute();

        // fetch() is the PDO method that get exactly one result
        return $query->fetch()->amount_of_songs;
    }*/
}
