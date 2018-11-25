package main

import (
	"fmt"
	"os"
	"net/http"
	"encoding/json"
	"github.com/gorilla/mux"
)

type Hello struct {
	Greetings string
	Version   string
}

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World")
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/api/{name}", func( w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json; charset=UTF-8")
		vars := mux.Vars(r)
		greetings := "Hello - " + vars["name"]
		
		msg := Hello{ 
			greetings, 
			os.Getenv("VERSION")}
		json.NewEncoder(w).Encode(msg)
	})
	r.HandleFunc("/", HomeHandler )
	http.ListenAndServe(":5000", r)
}