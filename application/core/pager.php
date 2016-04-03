<?php

class Pager{
    
    private $query_id;
    private $page;
    private $rows;
    private $sort_index;
    private $sort_direction;
    private $filter = '';
    
    public function __construct($db, $query_id, $page, $rows_to_display, $sort_index, $sort_direction, $filter = '') {
        try {
            $this->db = $db;
            $this->query_id = $query_id;
            $this->page = $page;
            $this->rows = $rows_to_display;
            $this->sort_index = $sort_index;
            $this->sort_direction = $sort_direction;
            $this->filter = $filter;
        }
        catch (PDOException $e){
            return "Database connection error.";
        }
    }
    
    public function createData(){
        $current_page = $this->page;
        $limit = $this->rows;
        
        $request = $this->getQuery();
        
        $count = $this->db->query('SELECT COUNT(*) AS count FROM '.$request->QueryName)->fetchColumn();
        
        if(!$this->sort_index){
            $this->sort_index = $request->KeyField;
            $this->sort_direction = "DESC"; 
        }
        
        if( $count >0 ) {
            $total_pages = ceil($count/$limit);
        }
        else{
            $total_pages = 0;
        }

        if ($current_page > $total_pages){
            $current_page = $total_pages;
        }

        $start = $limit * $current_page - $limit; 
        $output = new stdClass();
        $output->page = $current_page;
        $output->total = $total_pages;
        $output->records = $count;
        
        $text = sprintf('SELECT * FROM %s ORDER BY %s %s LIMIT %s, %s',$request->QueryName, $this->sort_index, $this->sort_direction, $start, $limit);

        $queries = $this->db->prepare($text);
        $queries->execute();
        $rows = $queries->fetchAll(PDO::FETCH_ASSOC);
        
        $i=0;
        foreach($rows as $result){
            $output->rows[$i] = $result;
            $i++;
        }
        //header('Content-Type: application/json');
        //echo json_encode($output);
        return $output;
    }
    private function getQuery(){
        $query = 'SELECT QueryName, KeyField FROM request_query WHERE QueryId = :query_id';
        $params = array(':query_id' => $this->query_id);
        
        $request_query = $this->db->prepare($query);
        $request_query->execute($params);
        return $request_query->fetchObject();
    }
}
