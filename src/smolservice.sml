(*
 * A simple echo server.
 *)

fun sendStr (s, str) =
  Socket.sendVec (s, Word8VectorSlice.full (Byte.stringToBytes str))

fun optOr NONE y = y
  | optOr (SOME x) _ = x

(* The handler loop is spawned for each connecting client *)
fun handleConnection s = (
    sendStr (s, "Welcome to the echo server!\r\n");
    sendStr (s, "Type 'quit' to exit.\r\n");
    echoLoop s;
    Socket.close s;
    print "Closed the connection.\n"
)
and echoLoop s =
  let
    val bytes = Socket.recvVec (s, 1024)
    val str = Byte.bytesToString bytes
  in
    case str of
      "quit\r\n" => sendStr (s, "Bye!\r\n")
    | _ => (sendStr (s, str); echoLoop s)
  end

(* The server entry point enters this loop waiting for connections *)
fun acceptLoop server_sock =
  let
    val _ = print "Waiting for connection...\n"
    val (s, _) = Socket.accept server_sock
  in
    print "Accepted connection, forking handler...\n";
    case Posix.Process.fork () of
      NONE => handleConnection s
    | SOME _ => acceptLoop server_sock
  end

fun main () =
  let
    val s = INetSock.TCP.socket ()
    val portOpt = Option.mapPartial Int.fromString (OS.Process.getEnv "PORT")
    val port = optOr portOpt 8989
  in
    Socket.Ctl.setREUSEADDR (s, true);
    Socket.bind (s, INetSock.any port);
    Socket.listen (s, 5);
    print ("Listening on port " ^ (Int.toString port) ^ "\n");
    acceptLoop s
  end
