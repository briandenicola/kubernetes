package main

import (
	"fmt"
	"net/http"
	"github.com/gorilla/mux"
)

func HomeHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World")
}

func main() {
	r := mux.NewRouter()
	r.HandleFunc("/api/{name}", func( w http.ResponseWriter, r *http.Request) {
		vars := mux.Vars(r)
		name := vars["name"]

		fmt.Fprintf(w, "Hello %s", name)
	})
	r.HandleFunc("/", HomeHandler )
	http.ListenAndServe(":5000", r)
}