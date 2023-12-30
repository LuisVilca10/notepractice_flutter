//tipos de notas
enum TypeNote {
  Text,
  Image,
  Network,
  TextImage,
  TextNetwork,
  ImageNetwork,
  TextImageNetwork
}
//estado de la nora
enum StateNote { Visible, Archive, Delete }
//estado de la tarea
enum StateTask { Done, Review, PastDate, Create }
//estados de conexion a internet
enum StatusNetwork {Connected, NoInternet, Exception}