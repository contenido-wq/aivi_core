-- ============================================================
-- RETO 15D — Carga de compradores + match de teléfonos
-- Generado: 2026-06-10 13:02
-- Registros: 1455
-- PASOS: ejecutar en orden, cada uno es idempotente (ON CONFLICT)
-- ============================================================

-- PASO 1: Insertar / actualizar transacciones Reto 15D
INSERT INTO transactions
  (hotmart_id, event_type, buyer_name, buyer_email, buyer_phone,
   buyer_country, plan_name, amount, currency, status, created_at)
VALUES
  ('RETO15D-crogutierrez@gmail.com', 'PURCHASE_COMPLETE', 'Carmenrosa Gutierrez Pinedo', 'crogutierrez@gmail.com', '15036289631', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-09T11:41:29'),
  ('RETO15D-mariamildreyzuluaga@icloud.com', 'PURCHASE_COMPLETE', 'Mildrey Zuluaga', 'mariamildreyzuluaga@icloud.com', '573106776127', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T09:21:36'),
  ('RETO15D-linaavilez@hotmail.com', 'PURCHASE_COMPLETE', 'Emelina Maria Avilez Diaz', 'linaavilez@hotmail.com', '573135128800', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T20:52:42'),
  ('RETO15D-juanda125@hotmail.com', 'PURCHASE_COMPLETE', 'juan david bustamante montoya', 'juanda125@hotmail.com', '573159265090', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T21:12:17'),
  ('RETO15D-greycmarseminario@gmail.com', 'PURCHASE_COMPLETE', 'Greycmar seminario', 'greycmarseminario@gmail.com', '34656328985', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-16T21:17:21'),
  ('RETO15D-alejandra.fernandez.redes@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Fernandez andrade', 'alejandra.fernandez.redes@gmail.com', '18296470242', 'DO', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-16T21:25:50'),
  ('RETO15D-jacar170@hotmail.com', 'PURCHASE_COMPLETE', 'Jair Díaz', 'jacar170@hotmail.com', '573192054938', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T21:27:08'),
  ('RETO15D-angeldie8383@gmail.com', 'PURCHASE_COMPLETE', 'Angélica María castaño Piedrahíta', 'angeldie8383@gmail.com', '573223716864', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T21:35:00'),
  ('RETO15D-andresjbd94@gmail.com', 'PURCHASE_COMPLETE', 'Andrés Jeussepe Blanco Durango', 'andresjbd94@gmail.com', '573112036580', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T21:50:17'),
  ('RETO15D-mcgmaryluz@gmail.com', 'PURCHASE_COMPLETE', 'Mary Luz Campos', 'mcgmaryluz@gmail.com', '573104456107', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T23:16:50'),
  ('RETO15D-nelsonramirezc2@gmail.com', 'PURCHASE_COMPLETE', 'Humberto Ramirez', 'nelsonramirezc2@gmail.com', '573102426113', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-16T23:46:22'),
  ('RETO15D-lutraveling.agencia@gmail.com', 'PURCHASE_COMPLETE', 'JHON FREDDY MORENO COPETE', 'lutraveling.agencia@gmail.com', '573172163491', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-01-17T11:07:30'),
  ('RETO15D-tatianagarcia2616@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana García Castañeda', 'tatianagarcia2616@gmail.com', '573147929390', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-17T16:39:48'),
  ('RETO15D-dahiana.cortes.toro@gmail.com', 'PURCHASE_COMPLETE', 'Dahiana cortes', 'dahiana.cortes.toro@gmail.com', '573225690279', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-01-17T21:36:04'),
  ('RETO15D-milagrosmjvr@hotmail.com', 'PURCHASE_COMPLETE', 'Milagros Villa', 'milagrosmjvr@hotmail.com', '584246825174', 'VE', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-18T22:55:47'),
  ('RETO15D-msmargaritasarmiento@gmail.com', 'PURCHASE_COMPLETE', 'Margarita Sarmiento', 'msmargaritasarmiento@gmail.com', '17866831492', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-20T14:25:08'),
  ('RETO15D-mariamejuto1708@gmail.com', 'PURCHASE_COMPLETE', 'Maria Mejuto', 'mariamejuto1708@gmail.com', '18506918276', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-20T22:52:28'),
  ('RETO15D-mailynok@hotmail.com', 'PURCHASE_COMPLETE', 'Maylin De Zubiria Grandett', 'mailynok@hotmail.com', '573007516402', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-21T08:43:27'),
  ('RETO15D-dcortesph@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Cortes', 'dcortesph@gmail.com', '573175803263', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-21T09:54:50'),
  ('RETO15D-jarojas.hernandez@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Andrés Rojas', 'jarojas.hernandez@gmail.com', '573167252700', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-21T11:09:57'),
  ('RETO15D-gustaavochaavez@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Chavez Conde', 'gustaavochaavez@gmail.com', '573114820834', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-21T13:38:38'),
  ('RETO15D-juancarlos.ecommerce@gmail.com', 'PURCHASE_COMPLETE', 'Juan Caro Carlos Caro', 'juancarlos.ecommerce@gmail.com', '573124910449', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-21T15:50:11'),
  ('RETO15D-kattyhealthcoach@gmail.com', 'PURCHASE_COMPLETE', 'Katiuska Bonilla', 'kattyhealthcoach@gmail.com', '115719917539', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-21T18:40:05'),
  ('RETO15D-agrimensurafondeur@hotmail.com', 'PURCHASE_COMPLETE', 'Leinizt Fondeur', 'agrimensurafondeur@hotmail.com', '18498174048', 'DO', 'Reto 15D', 36.94, 'USD', 'active', '2025-01-22T07:11:53'),
  ('RETO15D-lujanperezgeraldine@gmail.com', 'PURCHASE_COMPLETE', 'Santiago Tapias', 'lujanperezgeraldine@gmail.com', '573226003051', 'CO', 'Reto 15D', 0.37, 'USD', 'active', '2025-01-22T09:43:37'),
  ('RETO15D-caceres-itpro@outlook.com', 'PURCHASE_COMPLETE', 'Diego Cáceres', 'caceres-itpro@outlook.com', '573105167401', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-22T13:54:20'),
  ('RETO15D-davidramirezpersonal@gmail.com', 'PURCHASE_COMPLETE', 'David Ramirez Juarez', 'davidramirezpersonal@gmail.com', '522481331942', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-01-22T20:28:33'),
  ('RETO15D-hectorzamudio183@gmail.com', 'PURCHASE_COMPLETE', 'Héctor osnaider Zamudio Martinez', 'hectorzamudio183@gmail.com', '573229367175', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-22T22:28:00'),
  ('RETO15D-yyaqueline06@gmail.com', 'PURCHASE_COMPLETE', 'Yaqueline Otavo villamil', 'yyaqueline06@gmail.com', '573223685092', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-23T10:18:42'),
  ('RETO15D-valeriaruiz_24@hotmail.com', 'PURCHASE_COMPLETE', 'Valeria Ruiz', 'valeriaruiz_24@hotmail.com', '573209223039', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-01-23T21:15:02'),
  ('RETO15D-ximetello33@gmail.com', 'PURCHASE_COMPLETE', 'Ximena Tello', 'ximetello33@gmail.com', '573004487886', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-23T21:41:56'),
  ('RETO15D-jaramillovelasquezlaura@gmail.com', 'PURCHASE_COMPLETE', 'Laura Jaramillo', 'jaramillovelasquezlaura@gmail.com', '61452078220', 'AU', 'Reto 15D', 37.12, 'USD', 'active', '2025-01-23T21:55:09'),
  ('RETO15D-tessitore1975@hotmail.com', 'PURCHASE_COMPLETE', 'Fausto Eladio Tejedor Ramon', 'tessitore1975@hotmail.com', '5930991491861', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-23T22:57:43'),
  ('RETO15D-luisaechava@hotmail.com', 'PURCHASE_COMPLETE', 'Luisa Echavarria', 'luisaechava@hotmail.com', '573112263230', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-01-24T07:14:09'),
  ('RETO15D-julianmv@hotmail.com', 'PURCHASE_COMPLETE', 'Julian Moreno', 'julianmv@hotmail.com', '573147137970', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-24T07:21:12'),
  ('RETO15D-johncanoocasal@gmail.com', 'PURCHASE_COMPLETE', 'JOHN CANO OCASAL', 'johncanoocasal@gmail.com', '573173876699', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-24T09:15:54'),
  ('RETO15D-johanescuello27@gmail.com', 'PURCHASE_COMPLETE', 'Johanes Cuello', 'johanescuello27@gmail.com', '573207083307', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-24T16:52:16'),
  ('RETO15D-vd944@hotmail.com', 'PURCHASE_COMPLETE', 'Vanessa Diaz', 'vd944@hotmail.com', '573143272095', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-24T18:41:00'),
  ('RETO15D-stalinbravo55@gmail.com', 'PURCHASE_COMPLETE', 'Stalin Bravo', 'stalinbravo55@gmail.com', '5930983179938', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-24T19:07:44'),
  ('RETO15D-angelicasedi@hotmail.com', 'PURCHASE_COMPLETE', 'Maria Sendoya', 'angelicasedi@hotmail.com', '573213718410', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-25T06:03:03'),
  ('RETO15D-necha119@hotmail.com', 'PURCHASE_COMPLETE', 'Vanessa cantarero', 'necha119@hotmail.com', '50661195534', 'CR', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-25T07:50:21'),
  ('RETO15D-pinedaneyrakatheleenbrissette@gmail.com', 'PURCHASE_COMPLETE', 'Katheleen Pineda', 'pinedaneyrakatheleenbrissette@gmail.com', '393929573676', 'IT', 'Reto 15D', 35.71, 'USD', 'active', '2025-01-25T17:39:29'),
  ('RETO15D-raffocorantes@gmail.com', 'PURCHASE_COMPLETE', 'RAFAEL ALONZO CORANTES SANCHEZ NINA', 'raffocorantes@gmail.com', '51971500350', 'PE', 'Reto 15D', 36.96, 'USD', 'active', '2025-01-25T20:10:22'),
  ('RETO15D-frank.valverde89@gmail.com', 'PURCHASE_COMPLETE', 'Frank Nicols Valverde', 'frank.valverde89@gmail.com', '573217788879', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-26T07:00:09'),
  ('RETO15D-rony51087@gmail.com', 'PURCHASE_COMPLETE', 'Rony Campos', 'rony51087@gmail.com', '51944591478', 'PE', 'Reto 15D', 36.96, 'USD', 'active', '2025-01-26T09:44:58'),
  ('RETO15D-gvcapitalinvestment@gmail.com', 'PURCHASE_COMPLETE', 'Ignacio Villasenor', 'gvcapitalinvestment@gmail.com', '12108033569', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-26T09:48:04'),
  ('RETO15D-nataliajg1997@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Jiménez', 'nataliajg1997@gmail.com', '573107814332', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T16:09:59'),
  ('RETO15D-jmunevcla@live.com', 'PURCHASE_COMPLETE', 'Javier David Munevar', 'jmunevcla@live.com', '573134818862', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T16:56:15'),
  ('RETO15D-leidycordoba@gmail.com', 'PURCHASE_COMPLETE', 'Leidy Johanna Córdoba Acevedo', 'leidycordoba@gmail.com', '573117157630', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T18:04:33'),
  ('RETO15D-catalinaalzate0@gmail.com', 'PURCHASE_COMPLETE', 'Catalina Alzate', 'catalinaalzate0@gmail.com', '573052320099', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-27T18:44:07'),
  ('RETO15D-miguelferu@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Urquijo', 'miguelferu@gmail.com', '573015606277', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T19:31:21'),
  ('RETO15D-danilozcr@gmail.com', 'PURCHASE_COMPLETE', 'Danilo Zamora', 'danilozcr@gmail.com', '50684330068', 'CR', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T19:39:05'),
  ('RETO15D-marce_corredor@hotmail.com', 'PURCHASE_COMPLETE', 'Ana marcela corredor', 'marce_corredor@hotmail.com', '573006326905', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T19:45:06'),
  ('RETO15D-andresbel84@hotmail.com', 'PURCHASE_COMPLETE', 'Andrés mauricio Beltrán Hernández', 'andresbel84@hotmail.com', '573005690280', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-27T22:16:25'),
  ('RETO15D-carolina.carmona2@udea.edu.co', 'PURCHASE_COMPLETE', 'carolina carmona henao', 'carolina.carmona2@udea.edu.co', '573147121547', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-28T09:09:57'),
  ('RETO15D-lilimofl@hotmail.com', 'PURCHASE_COMPLETE', 'Liliana Maria Montoya Florez', 'lilimofl@hotmail.com', '573104039057', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-28T09:12:37'),
  ('RETO15D-liz@poleta.co', 'PURCHASE_COMPLETE', 'Lizeth Galvis', 'liz@poleta.co', '573016055080', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-28T09:46:59'),
  ('RETO15D-paulitamonsalve@hotmail.com', 'PURCHASE_COMPLETE', 'Paula Monsalve', 'paulitamonsalve@hotmail.com', '573122813447', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-28T12:32:22'),
  ('RETO15D-mabel.olivares2707@gmail.com', 'PURCHASE_COMPLETE', 'Mabel Olivares', 'mabel.olivares2707@gmail.com', '18323784074', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-28T14:44:02'),
  ('RETO15D-richi120901@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo hernandez reyes', 'richi120901@gmail.com', '573208623972', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-28T15:02:13'),
  ('RETO15D-guifoshamburguesas@gmail.com', 'PURCHASE_COMPLETE', 'Santiago Guido Duque', 'guifoshamburguesas@gmail.com', '573177767096', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-28T20:40:57'),
  ('RETO15D-vicodila.19@gmail.com', 'PURCHASE_COMPLETE', 'sandra lizeth victoria diaz', 'vicodila.19@gmail.com', '573164502536', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-29T14:17:49'),
  ('RETO15D-diegomonroy696@gmail.com', 'PURCHASE_COMPLETE', 'Diego Felipe Shwkyng Monroy', 'diegomonroy696@gmail.com', '573223121210', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-29T21:12:14'),
  ('RETO15D-steven.moreno155@gmail.com', 'PURCHASE_COMPLETE', 'Steven Moreno', 'steven.moreno155@gmail.com', '573195999136', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-30T20:47:16'),
  ('RETO15D-edwin050498@gmail.com', 'PURCHASE_COMPLETE', 'Edwin Cañas Largo', 'edwin050498@gmail.com', '573183552831', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-01-30T20:55:45'),
  ('RETO15D-johannabanoveliz@gmail.com', 'PURCHASE_COMPLETE', 'Emilyn Bano', 'johannabanoveliz@gmail.com', '14433197848', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-30T21:13:58'),
  ('RETO15D-maujr.94@gmail.com', 'PURCHASE_COMPLETE', 'Jesús Armando llanos', 'maujr.94@gmail.com', '573146825651', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-30T21:15:54'),
  ('RETO15D-geraldyne2112@gmail.com', 'PURCHASE_COMPLETE', 'Geraldyne Rios', 'geraldyne2112@gmail.com', '573015049597', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-30T22:34:47'),
  ('RETO15D-proyectosgrowth@gmail.com', 'PURCHASE_COMPLETE', 'Álvaro Bermúdez', 'proyectosgrowth@gmail.com', '573107508849', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-30T23:19:27'),
  ('RETO15D-yurymat@hotmail.com', 'PURCHASE_COMPLETE', 'YURY ANDREA MARTINEZ MEDINA', 'yurymat@hotmail.com', '573045331115', 'CO', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-31T07:59:34'),
  ('RETO15D-inverstru@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Muñoz', 'inverstru@gmail.com', '573166198645', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-31T08:49:36'),
  ('RETO15D-juliovillarreal84@hotmail.com', 'PURCHASE_COMPLETE', 'Julio César Villarreal González', 'juliovillarreal84@hotmail.com', '573155443972', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-01-31T11:37:07'),
  ('RETO15D-naranjoboteros@gmail.com', 'PURCHASE_COMPLETE', 'Sebastian Naranjo Botero', 'naranjoboteros@gmail.com', '573017911759', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-01-31T13:11:22'),
  ('RETO15D-penamata90@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Angel Peña Mata', 'penamata90@gmail.com', '51946856472', 'PE', 'Reto 15D', 37.38, 'USD', 'active', '2025-02-01T00:46:23'),
  ('RETO15D-mariav0531@hotmail.com', 'PURCHASE_COMPLETE', 'Maria Victoria Millan', 'mariav0531@hotmail.com', '573115917299', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-01T07:28:36'),
  ('RETO15D-muneramichel@outlook.es', 'PURCHASE_COMPLETE', 'Michell munera', 'muneramichel@outlook.es', '542216044017', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-02-01T10:37:28'),
  ('RETO15D-mauriciodiazrealtor@gmail.com', 'PURCHASE_COMPLETE', 'Mauricio Díaz González', 'mauriciodiazrealtor@gmail.com', '573154039866', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-01T17:13:01'),
  ('RETO15D-juliperu@gmail.com', 'PURCHASE_COMPLETE', 'Juliana Pérez Ruiz', 'juliperu@gmail.com', '573005720996', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-02T07:20:34'),
  ('RETO15D-natalia88saldana@gmail.com', 'PURCHASE_COMPLETE', 'Lorena Saldaña', 'natalia88saldana@gmail.com', '573146101142', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-02T21:18:18'),
  ('RETO15D-alejandra-626@hotmail.com', 'PURCHASE_COMPLETE', 'Diana hoyos', 'alejandra-626@hotmail.com', '573165200435', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-03T05:18:59'),
  ('RETO15D-monik25891@hotmail.com', 'PURCHASE_COMPLETE', 'Mónica carolina Trejo marin', 'monik25891@hotmail.com', '573145462315', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-03T07:47:36'),
  ('RETO15D-edison.patron.sabando@gmail.com', 'PURCHASE_COMPLETE', 'Edison Patron', 'edison.patron.sabando@gmail.com', '5930978685097', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-03T14:59:17'),
  ('RETO15D-erlymplaceres10@gmail.com', 'PURCHASE_COMPLETE', 'Erlym Placeres', 'erlymplaceres10@gmail.com', '116093020085', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-04T07:43:59'),
  ('RETO15D-mb4marketingagency@gmail.com', 'PURCHASE_COMPLETE', 'sergio rincon', 'mb4marketingagency@gmail.com', '573504649813', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-04T08:11:54'),
  ('RETO15D-vargasalvaradotatiana@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Vargas', 'vargasalvaradotatiana@gmail.com', '573012793741', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-04T08:13:05'),
  ('RETO15D-natalia881201@hotmail.com', 'PURCHASE_COMPLETE', 'Natalia Calderón Calderón', 'natalia881201@hotmail.com', '573214963877', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-04T08:25:48'),
  ('RETO15D-rafael.och8a@gmail.com', 'PURCHASE_COMPLETE', 'Rafael Ignacio Ochoa Ochoa', 'rafael.och8a@gmail.com', '573016157916', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-04T10:16:39'),
  ('RETO15D-fliaog65@gmail.com', 'PURCHASE_COMPLETE', 'Juan Camilo Oñate Gomez', 'fliaog65@gmail.com', '573006595089', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-04T10:32:05'),
  ('RETO15D-richardace2023@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo Acevedo', 'richardace2023@gmail.com', '573138724393', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-04T21:35:42'),
  ('RETO15D-luisis012664@gmail.com', 'PURCHASE_COMPLETE', 'Luisa Aristizabal', 'luisis012664@gmail.com', '573225692396', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-05T05:42:25'),
  ('RETO15D-creamostuestilo.empaquetados@gmail.com', 'PURCHASE_COMPLETE', 'Wendy Vanessa Castañeda Negrete', 'creamostuestilo.empaquetados@gmail.com', '573042491749', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-05T08:14:48'),
  ('RETO15D-suarezstev1@gmail.com', 'PURCHASE_COMPLETE', 'Steven Suarez', 'suarezstev1@gmail.com', '17542497075', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-05T12:54:19'),
  ('RETO15D-heidyjo.loa@gmail.com', 'PURCHASE_COMPLETE', 'Heidy Yohana Cabezas', 'heidyjo.loa@gmail.com', '16504764216', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-05T13:21:44'),
  ('RETO15D-juan.chicaiza.og@gmail.com', 'PURCHASE_COMPLETE', 'Juan Chicaiza', 'juan.chicaiza.og@gmail.com', '5930981896969', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-05T16:09:21'),
  ('RETO15D-mngomezc09@gmail.com', 'PURCHASE_COMPLETE', 'Mabel Gómez', 'mngomezc09@gmail.com', '573013639008', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-05T16:50:07'),
  ('RETO15D-everisieri@gmail.com', 'PURCHASE_COMPLETE', 'Ever Risieri Irala Ramirez', 'everisieri@gmail.com', '5950981753334', 'PY', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-05T20:09:35'),
  ('RETO15D-erikameneses0128@gmail.com', 'PURCHASE_COMPLETE', 'Erika Meneses', 'erikameneses0128@gmail.com', '573016775795', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-05T21:54:16'),
  ('RETO15D-jhonbrandon504@gmail.com', 'PURCHASE_COMPLETE', 'Jhon brandon florez', 'jhonbrandon504@gmail.com', '573133478949', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-05T23:02:10'),
  ('RETO15D-cristian.camarin@gmail.com', 'PURCHASE_COMPLETE', 'Cristian Camilo Marin Acosta', 'cristian.camarin@gmail.com', '573186966867', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T00:09:19'),
  ('RETO15D-carolina.ramos.em@gmail.com', 'PURCHASE_COMPLETE', 'Carolina Ramos', 'carolina.ramos.em@gmail.com', '573104066023', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T00:16:09'),
  ('RETO15D-hapedraza1@gmail.com', 'PURCHASE_COMPLETE', 'Hector Pedraza', 'hapedraza1@gmail.com', '19172130364', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-06T03:05:53'),
  ('RETO15D-jclo888@hotmail.com', 'PURCHASE_COMPLETE', 'Jenny Logaña', 'jclo888@hotmail.com', '593987869871', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-06T03:30:23'),
  ('RETO15D-aguamarinafashion@gmail.com', 'PURCHASE_COMPLETE', 'Jenny Florez', 'aguamarinafashion@gmail.com', '573128088236', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T06:20:31'),
  ('RETO15D-karenisa14@gmail.com', 'PURCHASE_COMPLETE', 'Karen oviedo', 'karenisa14@gmail.com', '112018877569', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-06T08:02:44'),
  ('RETO15D-jeiale0429@hotmail.com', 'PURCHASE_COMPLETE', 'Jeidy Alexandra Saray Abello', 'jeiale0429@hotmail.com', '573185218446', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T08:14:49'),
  ('RETO15D-brayanaguilarsas@gmail.com', 'PURCHASE_COMPLETE', 'Brayan Aguilar', 'brayanaguilarsas@gmail.com', '573182120380', 'CO', 'Reto 15D', 0.37, 'USD', 'active', '2025-02-06T12:04:06'),
  ('RETO15D-juanfraglez@gmail.com', 'PURCHASE_COMPLETE', 'ALTERNATIVAS Y PROCESOS DE PARTICIPACION SOCIAL', 'juanfraglez@gmail.com', '522381026515', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T12:33:46'),
  ('RETO15D-sofimartinez4994@hotmail.com', 'PURCHASE_COMPLETE', 'Gloria Martinez', 'sofimartinez4994@hotmail.com', '573043888677', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T14:33:12'),
  ('RETO15D-estefinarvaez-07@hotmail.com', 'PURCHASE_COMPLETE', 'Estefanny Narvaez', 'estefinarvaez-07@hotmail.com', '573145877018', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T16:14:53'),
  ('RETO15D-angus23sms@gmail.com', 'PURCHASE_COMPLETE', 'Sergio Sanguino', 'angus23sms@gmail.com', '573105554559', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T17:21:58'),
  ('RETO15D-valeriagonzales071024@gmail.com', 'PURCHASE_COMPLETE', 'Valeria González', 'valeriagonzales071024@gmail.com', '573206142656', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T20:56:06'),
  ('RETO15D-eileennrodriguez@gmail.com', 'PURCHASE_COMPLETE', 'Eileen Rodríguez', 'eileennrodriguez@gmail.com', '117137398223', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-06T21:37:22'),
  ('RETO15D-susanaarambulam@gmail.com', 'PURCHASE_COMPLETE', 'Susana arambula miñarro', 'susanaarambulam@gmail.com', '526681030853', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-02-06T22:43:12'),
  ('RETO15D-businessbynatacatano@gmail.com', 'PURCHASE_COMPLETE', 'natalia cataño', 'businessbynatacatano@gmail.com', '573104199649', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T05:47:22'),
  ('RETO15D-alejoravec@gmail.com', 'PURCHASE_COMPLETE', 'Didier Alejandro Rave Castillo', 'alejoravec@gmail.com', '573004830980', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T07:00:27'),
  ('RETO15D-vvu920618@gmail.com', 'PURCHASE_COMPLETE', 'Vanessa V', 'vvu920618@gmail.com', '573013473912', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T07:07:01'),
  ('RETO15D-silvanah2479@gmail.com', 'PURCHASE_COMPLETE', 'Astrid Silvana Hoyos Gomez', 'silvanah2479@gmail.com', '17869617609', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-07T07:58:49'),
  ('RETO15D-gonzalezd@ut.edu.co', 'PURCHASE_COMPLETE', 'Daniela González', 'gonzalezd@ut.edu.co', '573113797062', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T08:39:54'),
  ('RETO15D-nicolasmillan0532@gmail.com', 'PURCHASE_COMPLETE', 'Nicolas Becerra Millán', 'nicolasmillan0532@gmail.com', '117059297111', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T10:48:19'),
  ('RETO15D-arufino692@gmail.com', 'PURCHASE_COMPLETE', 'Alberto Rufino', 'arufino692@gmail.com', '527291100426', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-06T14:49:18'),
  ('RETO15D-ogomez0396@gmail.com', 'PURCHASE_COMPLETE', 'Oscar Gomez', 'ogomez0396@gmail.com', '573123174838', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T11:49:31'),
  ('RETO15D-geraldineandradep1019@gmail.com', 'PURCHASE_COMPLETE', 'Geraldine Andrade pantoja', 'geraldineandradep1019@gmail.com', '573165358424', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T11:58:06'),
  ('RETO15D-violetapaos@hotmail.com', 'PURCHASE_COMPLETE', 'Paola Andrea Arias García', 'violetapaos@hotmail.com', '573104946891', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T14:00:53'),
  ('RETO15D-lauralvargast@gmail.com', 'PURCHASE_COMPLETE', 'laura liceth vargas triana', 'lauralvargast@gmail.com', '573145969278', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-07T14:38:42'),
  ('RETO15D-kellintube@gmail.com', 'PURCHASE_COMPLETE', 'Kellin Yurani Tuberquia Betancur', 'kellintube@gmail.com', '573014711937', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T15:04:38'),
  ('RETO15D-valw09010@gmail.com', 'PURCHASE_COMPLETE', 'Lwendy Valeria Calderon Escalante', 'valw09010@gmail.com', '573213011254', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T21:20:21'),
  ('RETO15D-stevmachado07@gmail.com', 'PURCHASE_COMPLETE', 'Steven Ebrain Romich Machado Lozada', 'stevmachado07@gmail.com', '573105296214', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-07T21:45:12'),
  ('RETO15D-eduardogabriell2004@gmail.com', 'PURCHASE_COMPLETE', 'Gabriel Eduardo Blanco Rodriguez', 'eduardogabriell2004@gmail.com', '5804128541719', 'VE', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-07T21:59:04'),
  ('RETO15D-mabracho@gmail.com', 'PURCHASE_COMPLETE', 'Maria Bracho', 'mabracho@gmail.com', '114077562181', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-08T06:22:51'),
  ('RETO15D-santiagolopezm93@gmail.com', 'PURCHASE_COMPLETE', 'Santiago Lopez Martinez', 'santiagolopezm93@gmail.com', '14387220953', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-08T08:44:27'),
  ('RETO15D-leydy.plataa@gmail.com', 'PURCHASE_COMPLETE', 'Leydy Jhoayra Plata Céspedes', 'leydy.plataa@gmail.com', '573174238922', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-08T08:56:36'),
  ('RETO15D-lauragomez5413@gmail.com', 'PURCHASE_COMPLETE', 'Laura Gomez', 'lauragomez5413@gmail.com', '573136945040', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-08T09:46:16'),
  ('RETO15D-tatiana.palaciosplazas@gmail.com', 'PURCHASE_COMPLETE', 'Yuly Tatiana Palacios Plazas', 'tatiana.palaciosplazas@gmail.com', '19546736404', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-08T10:44:55'),
  ('RETO15D-karvalencia@gmail.com', 'PURCHASE_COMPLETE', 'Karen valencia diaz', 'karvalencia@gmail.com', '573218152963', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-08T10:50:07'),
  ('RETO15D-andresmoriones1909@gmail.com', 'PURCHASE_COMPLETE', 'Andres moriones', 'andresmoriones1909@gmail.com', '573137196461', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-08T13:03:12'),
  ('RETO15D-karenposadazapata@gmail.com', 'PURCHASE_COMPLETE', 'Karen Posada Zapata', 'karenposadazapata@gmail.com', '573042903922', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-08T13:58:53'),
  ('RETO15D-julian.vascocalle2@gmail.com', 'PURCHASE_COMPLETE', 'julian Vasco Calle', 'julian.vascocalle2@gmail.com', '573013212820', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-08T14:15:33'),
  ('RETO15D-claudiahappy74@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Portilla', 'claudiahappy74@gmail.com', '447857457007', 'GB', 'Reto 15D', 35.96, 'USD', 'active', '2025-02-08T15:52:49'),
  ('RETO15D-paulaquintero2024@gmail.com', 'PURCHASE_COMPLETE', 'Paula cespedes', 'paulaquintero2024@gmail.com', '573004227510', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-09T10:27:40'),
  ('RETO15D-maristi1210@gmail.com', 'PURCHASE_COMPLETE', 'Manuel Aristizabal', 'maristi1210@gmail.com', '573128214424', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-09T10:38:45'),
  ('RETO15D-megabella2020@gmail.com', 'PURCHASE_COMPLETE', 'Jose Luis Calderon', 'megabella2020@gmail.com', '573223910857', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-09T13:32:24'),
  ('RETO15D-andresrcamargo@gmail.com', 'PURCHASE_COMPLETE', 'Andres Rueda', 'andresrcamargo@gmail.com', '573105510116', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-09T18:28:34'),
  ('RETO15D-firstclassbeautybar1@gmail.com', 'PURCHASE_COMPLETE', 'Maggie Lopez Lopez', 'firstclassbeautybar1@gmail.com', '16176691465', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-09T19:52:14'),
  ('RETO15D-netjahlive@hotmail.com', 'PURCHASE_COMPLETE', 'Janet Franco', 'netjahlive@hotmail.com', '523322111186', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-10T10:39:13'),
  ('RETO15D-danielreyes2904@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Fabian Reyes Neira', 'danielreyes2904@gmail.com', '573004663651', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-10T15:51:02'),
  ('RETO15D-smosquera23@hotmail.com', 'PURCHASE_COMPLETE', 'Wendy Mosquera', 'smosquera23@hotmail.com', '573216972716', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-10T21:01:16'),
  ('RETO15D-jsernaz1990@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Serna zapata', 'jsernaz1990@gmail.com', '573022394127', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-11T07:57:48'),
  ('RETO15D-smoralescarrasquilla@gmail.com', 'PURCHASE_COMPLETE', 'Sebastián morales carrasquilla', 'smoralescarrasquilla@gmail.com', '573123427999', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-11T13:47:23'),
  ('RETO15D-montoyajuliana7@gmail.com', 'PURCHASE_COMPLETE', 'Juliana tejada montoya', 'montoyajuliana7@gmail.com', '573003813503', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-11T15:20:19'),
  ('RETO15D-crisacar81@gmail.com', 'PURCHASE_COMPLETE', 'Crispin Ariel Cartagena Gomez', 'crisacar81@gmail.com', '573107959002', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-12T07:58:05'),
  ('RETO15D-hbce09@gmail.com', 'PURCHASE_COMPLETE', 'HUMBERTO BERNARD CESAR ESPITIA', 'hbce09@gmail.com', '573243679396', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-12T14:23:38'),
  ('RETO15D-juancamilomunoz16@gmail.com', 'PURCHASE_COMPLETE', 'Juan Munoz', 'juancamilomunoz16@gmail.com', '13472956297', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-12T20:33:17'),
  ('RETO15D-eco.carlosvalencia7@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Valencia', 'eco.carlosvalencia7@gmail.com', '573176165090', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-12T20:30:01'),
  ('RETO15D-luizingonzalez@hotmail.com', 'PURCHASE_COMPLETE', 'Luis gonzalez mendez', 'luizingonzalez@hotmail.com', '529991105072', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-02-13T00:57:41'),
  ('RETO15D-chaconclau@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Chacón', 'chaconclau@gmail.com', '573208471796', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-13T08:55:39'),
  ('RETO15D-robingamez11usa@gmail.com', 'PURCHASE_COMPLETE', 'Robinson Gamez', 'robingamez11usa@gmail.com', '13218953484', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-13T09:52:12'),
  ('RETO15D-ruisusan1@gmail.com', 'PURCHASE_COMPLETE', 'Luis Salazar', 'ruisusan1@gmail.com', '34690296508', 'AD', 'Reto 15D', 36.39, 'USD', 'active', '2025-02-13T10:15:08'),
  ('RETO15D-juanita.lc46@gmail.com', 'PURCHASE_COMPLETE', 'Juanita Londoño Cardona', 'juanita.lc46@gmail.com', '573123197598', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-13T10:36:02'),
  ('RETO15D-claudiacv733@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Castano', 'claudiacv733@gmail.com', '12392904862', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-13T11:02:31'),
  ('RETO15D-marcela96pereira@hotmail.com', 'PURCHASE_COMPLETE', 'Robinson Pereira', 'marcela96pereira@hotmail.com', '573177139928', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-13T11:42:57'),
  ('RETO15D-stephanny.oberto@gmail.com', 'PURCHASE_COMPLETE', 'Stephanny Alejandra Oberto', 'stephanny.oberto@gmail.com', '573212248163', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-13T14:28:33'),
  ('RETO15D-mjandresorozco@gmail.com', 'PURCHASE_COMPLETE', 'Andres orozco', 'mjandresorozco@gmail.com', '573174670808', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T01:19:37'),
  ('RETO15D-juliethlopezmentora@gmail.com', 'PURCHASE_COMPLETE', 'Julieth Lopez', 'juliethlopezmentora@gmail.com', '573187706164', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T02:42:40'),
  ('RETO15D-simonhurtado37@gmail.com', 'PURCHASE_COMPLETE', 'Simon Hurtado Betancur', 'simonhurtado37@gmail.com', '573002377716', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T07:22:21'),
  ('RETO15D-jahircarrillo60@gmail.com', 'PURCHASE_COMPLETE', 'Alex Carrillo', 'jahircarrillo60@gmail.com', '5930985930116', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-14T07:49:50'),
  ('RETO15D-amalfyh_74@hotmail.com', 'PURCHASE_COMPLETE', 'Amalfy Arce Medina', 'amalfyh_74@hotmail.com', '34631883082', 'ES', 'Reto 15D', 35.56, 'USD', 'active', '2025-02-14T08:00:27'),
  ('RETO15D-santipatino3@gmail.com', 'PURCHASE_COMPLETE', 'Santiago Patiño Bustamante', 'santipatino3@gmail.com', '573106694138', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T09:38:07'),
  ('RETO15D-waffleticali@gmail.com', 'PURCHASE_COMPLETE', 'Saira Ospina', 'waffleticali@gmail.com', '573001558657', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-14T11:32:03'),
  ('RETO15D-avilaagustin299@gmail.com', 'PURCHASE_COMPLETE', 'Agustín Ávila', 'avilaagustin299@gmail.com', '542645877587', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-02-14T11:42:07'),
  ('RETO15D-valeriamazo37@gmail.com', 'PURCHASE_COMPLETE', 'Valeria Zuleta', 'valeriamazo37@gmail.com', '573244529355', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T12:09:29'),
  ('RETO15D-andresarias1128@gmail.com', 'PURCHASE_COMPLETE', 'Andres Felipe Arias Posada', 'andresarias1128@gmail.com', '573226388768', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T12:23:03'),
  ('RETO15D-nagb77@gmail.com', 'PURCHASE_COMPLETE', 'Nina Gutierrez', 'nagb77@gmail.com', '12142708537', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-14T12:48:23'),
  ('RETO15D-h.patricia.pena@gmail.com', 'PURCHASE_COMPLETE', 'Henny Patricia Peña M', 'h.patricia.pena@gmail.com', '573013935453', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T15:27:29'),
  ('RETO15D-yannadelvalle@gmail.com', 'PURCHASE_COMPLETE', 'Yanna del Valle', 'yannadelvalle@gmail.com', '573005021007', 'CO', 'Reto 15D', 37.13, 'USD', 'active', '2025-02-14T15:38:58'),
  ('RETO15D-riverosstiven06@gmail.com', 'PURCHASE_COMPLETE', 'JORGE STIVEN RIVEROS ESPEJO', 'riverosstiven06@gmail.com', '573042001070', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T16:31:52'),
  ('RETO15D-jennifergiraldo2011@gmail.com', 'PURCHASE_COMPLETE', 'Jennifer Giraldo', 'jennifergiraldo2011@gmail.com', '13525309330', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-14T17:30:08'),
  ('RETO15D-ferrolon37@gmail.com', 'PURCHASE_COMPLETE', 'Fernando Rolón', 'ferrolon37@gmail.com', '595986129927', 'PY', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-14T17:38:34'),
  ('RETO15D-angelo_ramirez1204@hotmail.com', 'PURCHASE_COMPLETE', 'Angelo Ramirez', 'angelo_ramirez1204@hotmail.com', '34634130734', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-15T13:17:55'),
  ('RETO15D-marketing.13kk@gmail.com', 'PURCHASE_COMPLETE', 'Camilo Garzon O', 'marketing.13kk@gmail.com', '573188335032', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-15T18:40:33'),
  ('RETO15D-didiergalindo20@gmail.com', 'PURCHASE_COMPLETE', 'didier berrio galindo', 'didiergalindo20@gmail.com', '573105938975', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-15T22:42:47'),
  ('RETO15D-gladyssantizo4@gmail.com', 'PURCHASE_COMPLETE', 'Gladys Santizo', 'gladyssantizo4@gmail.com', '12817010685', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-15T23:38:15'),
  ('RETO15D-jenny.paola.acosta94@gmail.com', 'PURCHASE_COMPLETE', 'Jenny Paola Acosta', 'jenny.paola.acosta94@gmail.com', '573202393161', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-16T10:24:06'),
  ('RETO15D-info@ecologictravel.com.ar', 'PURCHASE_COMPLETE', 'Marcelo Javier Perucchi', 'info@ecologictravel.com.ar', '543772638112', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-02-16T16:03:26'),
  ('RETO15D-carloshidalgo.dvs@icloud.com', 'PURCHASE_COMPLETE', 'Carlos Hidalgo', 'carloshidalgo.dvs@icloud.com', '117322772177', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-16T22:58:26'),
  ('RETO15D-sandrasalas16@icloud.com', 'PURCHASE_COMPLETE', 'Sandra salas alvarez', 'sandrasalas16@icloud.com', '118458933928', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-17T09:16:26'),
  ('RETO15D-ppsalo24@gmail.com', 'PURCHASE_COMPLETE', 'Pablo Sanchez', 'ppsalo24@gmail.com', '573144345317', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-17T19:42:03'),
  ('RETO15D-leisan85@hotmail.com', 'PURCHASE_COMPLETE', 'Leydy sanchez henao', 'leisan85@hotmail.com', '573183397828', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-18T07:05:47'),
  ('RETO15D-contacto@dseo.cl', 'PURCHASE_COMPLETE', 'Joseph Cuevas', 'contacto@dseo.cl', '56987438933', 'CL', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-18T15:52:37'),
  ('RETO15D-rosis2554@gmail.com', 'PURCHASE_COMPLETE', 'Rosa Morales', 'rosis2554@gmail.com', '16232022714', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-18T19:46:11'),
  ('RETO15D-alexandervelez65@gmail.com', 'PURCHASE_COMPLETE', 'Alexander Madrid', 'alexandervelez65@gmail.com', '573197318907', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-18T21:44:02'),
  ('RETO15D-stefanyuliethernandez@gmail.com', 'PURCHASE_COMPLETE', 'Stefany Hernandez', 'stefanyuliethernandez@gmail.com', '573234373165', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T00:25:56'),
  ('RETO15D-m1atdianabedoya@gmail.com', 'PURCHASE_COMPLETE', 'Diana Bedoya Bedoya', 'm1atdianabedoya@gmail.com', '573007827689', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T00:59:43'),
  ('RETO15D-julianramirezv@me.com', 'PURCHASE_COMPLETE', 'Julian Ramirez Velez', 'julianramirezv@me.com', '573182526996', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T02:00:00'),
  ('RETO15D-mharboleda@gmail.com', 'PURCHASE_COMPLETE', 'Maria Helena Arboleda D', 'mharboleda@gmail.com', '573108318163', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T08:00:43'),
  ('RETO15D-santiagotapiasc+reto@gmail.com', 'PURCHASE_COMPLETE', 'Santiago Tapias', 'santiagotapiasc+reto@gmail.com', '573218373613', 'CO', 'Reto 15D', 0.37, 'USD', 'active', '2025-02-19T09:25:33'),
  ('RETO15D-jtrujillobetancur+reto@gmail.com', 'PURCHASE_COMPLETE', 'Jhei Trujillo', 'jtrujillobetancur+reto@gmail.com', '573105744045', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T09:32:29'),
  ('RETO15D-creativetiendacol@gmail.com', 'PURCHASE_COMPLETE', 'Katerine Tocancipa Gutierrez', 'creativetiendacol@gmail.com', '573022091014', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T10:50:13'),
  ('RETO15D-ktgonzalezp9027@gmail.com', 'PURCHASE_COMPLETE', 'katerine gonzalez', 'ktgonzalezp9027@gmail.com', '573205090085', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T11:10:01'),
  ('RETO15D-truebarbersmx@gmail.com', 'PURCHASE_COMPLETE', 'Gerson Sandoval Esparza', 'truebarbersmx@gmail.com', '528126604733', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-02-19T12:23:50'),
  ('RETO15D-estefania.garcia1400@gmail.com', 'PURCHASE_COMPLETE', 'Estefania Garcia', 'estefania.garcia1400@gmail.com', '573215414722', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T22:42:37'),
  ('RETO15D-paomazo@gmail.com', 'PURCHASE_COMPLETE', 'Paola mazo', 'paomazo@gmail.com', '573106364175', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-19T23:36:09'),
  ('RETO15D-ladoctoracerebro@gmail.com', 'PURCHASE_COMPLETE', 'Pilar Fierro', 'ladoctoracerebro@gmail.com', '573115065846', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T06:49:01'),
  ('RETO15D-moniacpa@gmail.com', 'PURCHASE_COMPLETE', 'Mónica Acosta', 'moniacpa@gmail.com', '573184014448', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T07:55:30'),
  ('RETO15D-msanchezc97@gmail.com', 'PURCHASE_COMPLETE', 'Martin Sanchez', 'msanchezc97@gmail.com', '573044490502', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T15:47:51'),
  ('RETO15D-carlosavendano@hotmail.com', 'PURCHASE_COMPLETE', 'Carlos avendano', 'carlosavendano@hotmail.com', '19723591489', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-20T15:49:21'),
  ('RETO15D-daniel.outdoor.96@gmail.com', 'PURCHASE_COMPLETE', 'Juan Daniel Lopez Posada', 'daniel.outdoor.96@gmail.com', '573008714657', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T18:40:18'),
  ('RETO15D-juliana@investopi.com', 'PURCHASE_COMPLETE', 'Juliana matiz', 'juliana@investopi.com', '573105314237', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T21:01:46'),
  ('RETO15D-marcelarodriguezcaro@yahoo.com', 'PURCHASE_COMPLETE', 'Diana Marcela Rodríguez Caro', 'marcelarodriguezcaro@yahoo.com', '573228470840', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T21:08:11'),
  ('RETO15D-loreg97personal@gmail.com', 'PURCHASE_COMPLETE', 'Lorena Gomez', 'loreg97personal@gmail.com', '573182442565', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-20T21:27:20'),
  ('RETO15D-dmoyaarevalo78@gmail.com', 'PURCHASE_COMPLETE', 'Diana Moya', 'dmoyaarevalo78@gmail.com', '16055156175', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-20T21:51:51'),
  ('RETO15D-aafragozo@gmail.com', 'PURCHASE_COMPLETE', 'Ana Angel Fragozo Britto', 'aafragozo@gmail.com', '573116706031', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-21T07:25:53'),
  ('RETO15D-ingvhcamargo@hotmail.com', 'PURCHASE_COMPLETE', 'Victor h Camargo s', 'ingvhcamargo@hotmail.com', '573113789612', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-21T07:40:20'),
  ('RETO15D-anviju0220@gmail.com', 'PURCHASE_COMPLETE', 'Angie Viviana Figueroa Farfan', 'anviju0220@gmail.com', '573125918167', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-21T10:02:02'),
  ('RETO15D-mauriciogiraldo7877@politecnicomayor.edu.co', 'PURCHASE_COMPLETE', 'Mauricio Giraldo', 'mauriciogiraldo7877@politecnicomayor.edu.co', '573226699521', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-21T13:20:53'),
  ('RETO15D-dannae_martinez@hotmail.com', 'PURCHASE_COMPLETE', 'CLAUDIA MARTINEZ', 'dannae_martinez@hotmail.com', '573214581798', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-21T14:44:26'),
  ('RETO15D-eliana0627gomez@gmail.com', 'PURCHASE_COMPLETE', 'Eliana Gomez', 'eliana0627gomez@gmail.com', '573204871414', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-21T17:43:40'),
  ('RETO15D-jenny.r8@hotmail.com', 'PURCHASE_COMPLETE', 'Yenny palla roa', 'jenny.r8@hotmail.com', '573138577664', 'TH', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-21T21:43:35'),
  ('RETO15D-fa503636@gmail.com', 'PURCHASE_COMPLETE', 'Franco Alvarado', 'fa503636@gmail.com', '51957678106', 'PE', 'Reto 15D', 37.16, 'USD', 'active', '2025-02-21T22:08:18'),
  ('RETO15D-quicenoandrea87@gmail.com', 'PURCHASE_COMPLETE', 'Andrea Quiceno', 'quicenoandrea87@gmail.com', '573003349669', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-22T07:54:21'),
  ('RETO15D-astridbedoya24@gmsil.com', 'PURCHASE_COMPLETE', 'Astrid Bedoya', 'astridbedoya24@gmsil.com', '573183514807', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-22T09:19:53'),
  ('RETO15D-samuelfelpa@gmail.com', 'PURCHASE_COMPLETE', 'Samuel perez patiño', 'samuelfelpa@gmail.com', '573196482486', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-22T10:20:41'),
  ('RETO15D-margaritacastillolaviada@gmail.com', 'PURCHASE_COMPLETE', 'Margarita castillo', 'margaritacastillolaviada@gmail.com', '529993638643', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-02-22T13:38:47'),
  ('RETO15D-yormarymontesg@gmail.com', 'PURCHASE_COMPLETE', 'Yor Mary Montes', 'yormarymontesg@gmail.com', '573188956320', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-22T14:07:41'),
  ('RETO15D-jgarnicajimenez@gmail.com', 'PURCHASE_COMPLETE', 'Julian Garnica', 'jgarnicajimenez@gmail.com', '573113830402', 'CO', 'Reto 15D', 36.82, 'USD', 'active', '2025-02-22T15:41:13'),
  ('RETO15D-yisnesuarez02@gmail.com', 'PURCHASE_COMPLETE', 'Yisney suarez', 'yisnesuarez02@gmail.com', '17262448105', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-22T20:50:58'),
  ('RETO15D-alejandra.sape@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Salazar', 'alejandra.sape@gmail.com', '573128968570', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-22T21:35:16'),
  ('RETO15D-genera.propiedades.mx@gmail.com', 'PURCHASE_COMPLETE', 'jessica pineda', 'genera.propiedades.mx@gmail.com', '525541331877', 'MX', 'Reto 15D', 36.95, 'USD', 'active', '2025-02-22T23:59:03'),
  ('RETO15D-cdagudelo94@gmail.com', 'PURCHASE_COMPLETE', 'Cesar David Agudelo', 'cdagudelo94@gmail.com', '573186234803', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-23T12:57:48'),
  ('RETO15D-johanalizgomez@gmail.com', 'PURCHASE_COMPLETE', 'Johana Gomez', 'johanalizgomez@gmail.com', '573202322945', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-23T17:51:59'),
  ('RETO15D-eliana.gomezmunoz@gmail.com', 'PURCHASE_COMPLETE', 'Eliana Gómez Muñoz', 'eliana.gomezmunoz@gmail.com', '573194849004', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-23T20:55:11'),
  ('RETO15D-aureliaquinonez@gmail.com', 'PURCHASE_COMPLETE', 'Aurelia Quiñonez Quiñonez', 'aureliaquinonez@gmail.com', '573166903386', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-23T20:56:56'),
  ('RETO15D-ingclaudiazuluaga@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Maria Zuluaga Giraldo', 'ingclaudiazuluaga@gmail.com', '573104610660', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-23T23:22:11'),
  ('RETO15D-eleramosbe@gmail.com', 'PURCHASE_COMPLETE', 'Maria Elena Ramos Berrocal', 'eleramosbe@gmail.com', '34656931454', 'ES', 'Reto 15D', 35.58, 'USD', 'active', '2025-02-24T08:26:19'),
  ('RETO15D-davidrom9905@gmail.com', 'PURCHASE_COMPLETE', 'David Romala', 'davidrom9905@gmail.com', '573058148833', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T08:33:42'),
  ('RETO15D-cabran112@gmail.com', 'PURCHASE_COMPLETE', 'Cristian Bran', 'cabran112@gmail.com', '573105961049', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T09:04:35'),
  ('RETO15D-leidyjquintanilla@gmail.com', 'PURCHASE_COMPLETE', 'Leidy Quintanilla', 'leidyjquintanilla@gmail.com', '573167959444', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T09:20:26'),
  ('RETO15D-miguelfranco94@hotmail.com', 'PURCHASE_COMPLETE', 'Miguel Andres Franco Arango', 'miguelfranco94@hotmail.com', '573004493784', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T10:04:21'),
  ('RETO15D-bocanegranogueraangie@gmail.com', 'PURCHASE_COMPLETE', 'Angie Bocanegra', 'bocanegranogueraangie@gmail.com', '573108966634', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T10:31:46'),
  ('RETO15D-karla.cgommez32@gmail.com', 'PURCHASE_COMPLETE', 'Karla Gomez', 'karla.cgommez32@gmail.com', '16693459230', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-24T11:03:51'),
  ('RETO15D-vividuran2015@gmail.com', 'PURCHASE_COMPLETE', 'Viviana duran', 'vividuran2015@gmail.com', '573209064307', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T11:56:13'),
  ('RETO15D-katherine.cortess1@gmail.com', 'PURCHASE_COMPLETE', 'Katherine cortes', 'katherine.cortess1@gmail.com', '573165329994', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T13:19:41'),
  ('RETO15D-danielcorrealopez11@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Correa', 'danielcorrealopez11@gmail.com', '573024141134', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T14:45:33'),
  ('RETO15D-castillomaria911005@gmail.com', 'PURCHASE_COMPLETE', 'María castillo', 'castillomaria911005@gmail.com', '573053200511', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T16:07:51'),
  ('RETO15D-dianaraquelpenar@gmail.com', 'PURCHASE_COMPLETE', 'Diana Raquel Peña Rodríguez', 'dianaraquelpenar@gmail.com', '573016785136', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T19:50:36'),
  ('RETO15D-davidpe30@outlook.com', 'PURCHASE_COMPLETE', 'David pena duenas', 'davidpe30@outlook.com', '573204460682', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-24T23:37:39'),
  ('RETO15D-nini-jhova@hotmail.com', 'PURCHASE_COMPLETE', 'johana narvaez', 'nini-jhova@hotmail.com', '573144200564', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T06:20:06'),
  ('RETO15D-cruzheidy58@gmail.com', 'PURCHASE_COMPLETE', 'Heidy Cruz', 'cruzheidy58@gmail.com', '573052929053', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T06:49:05'),
  ('RETO15D-cablanpa@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Blanco', 'cablanpa@gmail.com', '573152116116', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T07:07:27'),
  ('RETO15D-jgvroach19@outlook.com', 'PURCHASE_COMPLETE', 'Jonathan Gonzalez Vallejo', 'jgvroach19@outlook.com', '50683069420', 'CR', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T07:41:17'),
  ('RETO15D-yessikap9301@gmail.com', 'PURCHASE_COMPLETE', 'Yessica paola Mendoza Aguilar', 'yessikap9301@gmail.com', '573024025941', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T07:41:14'),
  ('RETO15D-judaniel16@gmail.com', 'PURCHASE_COMPLETE', 'Juan Daniel Marin Galvis', 'judaniel16@gmail.com', '573227028201', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T09:04:08'),
  ('RETO15D-zayratriana@hotmail.com', 'PURCHASE_COMPLETE', 'ZAYRA XIMENA TRIANA', 'zayratriana@hotmail.com', '573162570827', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T09:14:09'),
  ('RETO15D-felipe25733@gmail.com', 'PURCHASE_COMPLETE', 'Andres Suarez', 'felipe25733@gmail.com', '573130539670', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T11:48:27'),
  ('RETO15D-cmelannyb@gmail.com', 'PURCHASE_COMPLETE', 'Melanny Paola Cervantes Bermúdez', 'cmelannyb@gmail.com', '573126566680', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T11:55:13'),
  ('RETO15D-samluis292@gmail.com', 'PURCHASE_COMPLETE', 'Luis Evelio García Rodríguez', 'samluis292@gmail.com', '573182548081', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T15:39:23'),
  ('RETO15D-marito8601@hotmail.com', 'PURCHASE_COMPLETE', 'Mario Chaparro', 'marito8601@hotmail.com', '573108616357', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-25T18:05:48'),
  ('RETO15D-ingsheilabelandria@gmail.com', 'PURCHASE_COMPLETE', 'Sheila Belandria Belandria', 'ingsheilabelandria@gmail.com', '573208181707', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-25T21:23:13'),
  ('RETO15D-valenmuch70@gmail.com', 'PURCHASE_COMPLETE', 'valentina gomez', 'valenmuch70@gmail.com', '573176412813', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T21:44:26'),
  ('RETO15D-danielaortizb7@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Ortiz', 'danielaortizb7@gmail.com', '573004885689', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-25T22:18:35'),
  ('RETO15D-claudiagiselle84@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Benavides', 'claudiagiselle84@gmail.com', '51960531314', 'PE', 'Reto 15D', 37.22, 'USD', 'active', '2025-02-25T22:23:59'),
  ('RETO15D-juanabenavides0815@gmail.com', 'PURCHASE_COMPLETE', 'Juana Benavides', 'juanabenavides0815@gmail.com', '573104874558', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-26T00:12:56'),
  ('RETO15D-gustavovasquez.1624@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Adolfo Vasquez Hernández', 'gustavovasquez.1624@gmail.com', '573167446552', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T08:38:48'),
  ('RETO15D-isaromero2021@gmail.com', 'PURCHASE_COMPLETE', 'Isabel romero', 'isaromero2021@gmail.com', '573008035827', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T08:42:35'),
  ('RETO15D-bymayelaroman@gmail.com', 'PURCHASE_COMPLETE', 'Mayela Roman', 'bymayelaroman@gmail.com', '17868706272', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-26T10:25:51'),
  ('RETO15D-jomiva@hotmail.com', 'PURCHASE_COMPLETE', 'Jose Miguel Vargas', 'jomiva@hotmail.com', '573128389663', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-26T11:27:52'),
  ('RETO15D-jucaloba3@gmail.com', 'PURCHASE_COMPLETE', 'Juan Camilo Lopez', 'jucaloba3@gmail.com', '573004862158', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T12:02:27'),
  ('RETO15D-milenag227@gmail.com', 'PURCHASE_COMPLETE', 'Yadil Milena Galvis Hernández', 'milenag227@gmail.com', '573159272911', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T12:02:59'),
  ('RETO15D-vl2683431@gmail.com', 'PURCHASE_COMPLETE', 'Victor manuel lopez mejia', 'vl2683431@gmail.com', '573145502087', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T12:15:33'),
  ('RETO15D-yurani.v.garcia@gmail.com', 'PURCHASE_COMPLETE', 'Yurani Viviana García Alfonso', 'yurani.v.garcia@gmail.com', '573213889581', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T12:24:47'),
  ('RETO15D-jose-ts01@outlook.com', 'PURCHASE_COMPLETE', 'José Luis tangarife sanchez', 'jose-ts01@outlook.com', '573238110338', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T12:56:11'),
  ('RETO15D-davidbarpf@hotmail.com', 'PURCHASE_COMPLETE', 'David Barrios Chávez', 'davidbarpf@hotmail.com', '525516512769', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-02-26T14:15:27'),
  ('RETO15D-erikanavas24@gmail.com', 'PURCHASE_COMPLETE', 'Erika Navas', 'erikanavas24@gmail.com', '13059249981', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-26T15:44:14'),
  ('RETO15D-cursosgpo@gmail.com', 'PURCHASE_COMPLETE', 'Cristian Salgado', 'cursosgpo@gmail.com', '573177772392', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T17:04:00'),
  ('RETO15D-mhperez1801@gmail.com', 'PURCHASE_COMPLETE', 'Maria helena perez', 'mhperez1801@gmail.com', '573015481345', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T18:49:26'),
  ('RETO15D-juli.riveracr@gmail.com', 'PURCHASE_COMPLETE', 'Julieth Rivera', 'juli.riveracr@gmail.com', '573164429059', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-26T20:12:27'),
  ('RETO15D-francofuentes2@gmail.com', 'PURCHASE_COMPLETE', 'Jhon Fredy Franco Giraldo', 'francofuentes2@gmail.com', '573102176760', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-26T20:40:13'),
  ('RETO15D-hola@efectogrowth.com', 'PURCHASE_COMPLETE', 'Oscar Javier Salazar Amaya', 'hola@efectogrowth.com', '573012522914', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-26T21:01:37'),
  ('RETO15D-karenrojasm19@gmail.com', 'PURCHASE_COMPLETE', 'Karen Paola Rojas Mamani', 'karenrojasm19@gmail.com', '51928793874', 'PE', 'Reto 15D', 37.22, 'USD', 'active', '2025-02-27T00:23:25'),
  ('RETO15D-gomezserna.paola@gmail.com', 'PURCHASE_COMPLETE', 'Paola Andrea Gomez Serna', 'gomezserna.paola@gmail.com', '573176457856', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T06:47:20'),
  ('RETO15D-felipecurvelo@hotmail.com', 'PURCHASE_COMPLETE', 'Felipe Curvelo', 'felipecurvelo@hotmail.com', '573103243375', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T07:30:12'),
  ('RETO15D-rosalia_jaol@hotmail.com', 'PURCHASE_COMPLETE', 'Rosalia leon', 'rosalia_jaol@hotmail.com', '14695603691', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-27T08:28:32'),
  ('RETO15D-ginatbaldion@gmail.com', 'PURCHASE_COMPLETE', 'gina paola Triviño Baldion', 'ginatbaldion@gmail.com', '573107894475', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T09:05:29'),
  ('RETO15D-jencano18@gmail.com', 'PURCHASE_COMPLETE', 'Jennifer Cano', 'jencano18@gmail.com', '573153865634', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T09:26:33'),
  ('RETO15D-carloscartagena2405@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Cartagena', 'carloscartagena2405@gmail.com', '573007016022', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T09:46:12'),
  ('RETO15D-marce.1524@hotmail.com', 'PURCHASE_COMPLETE', 'Leslie Marcela Gomez Cardenas', 'marce.1524@hotmail.com', '573027133990', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-02-27T09:58:56'),
  ('RETO15D-cmurillomurillo92@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Daniel Murillo', 'cmurillomurillo92@gmail.com', '573006056506', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T15:24:16'),
  ('RETO15D-osanchez9991@gmail.com', 'PURCHASE_COMPLETE', 'Omar Sanchez Mondragón', 'osanchez9991@gmail.com', '50495192673', 'HN', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-27T15:58:26'),
  ('RETO15D-juanfmarulanda00@outlook.com', 'PURCHASE_COMPLETE', 'Juan Felipe Marulanda Pérez', 'juanfmarulanda00@outlook.com', '573123490968', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-27T22:31:43'),
  ('RETO15D-astronomo87@gmail.com', 'PURCHASE_COMPLETE', 'COSMOSHOP SAS', 'astronomo87@gmail.com', '573136029013', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T00:38:08'),
  ('RETO15D-adeanahbl@gmail.com', 'PURCHASE_COMPLETE', 'Adeana Garcia Paz', 'adeanahbl@gmail.com', '573178883544', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T07:16:30'),
  ('RETO15D-lorygil26@gmail.com', 'PURCHASE_COMPLETE', 'Loren rendon gil', 'lorygil26@gmail.com', '573008490828', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T07:49:21'),
  ('RETO15D-wendytamayo@hotmail.com', 'PURCHASE_COMPLETE', 'Wendy Arenas', 'wendytamayo@hotmail.com', '573134730717', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T08:02:53'),
  ('RETO15D-adsjoserojas@gmail.com', 'PURCHASE_COMPLETE', 'José rojas', 'adsjoserojas@gmail.com', '5930987763094', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-28T08:19:37'),
  ('RETO15D-ardila.ing@gmail.com', 'PURCHASE_COMPLETE', 'Ariel Ardila', 'ardila.ing@gmail.com', '573166073360', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T09:17:19'),
  ('RETO15D-martinabenal@hotmail.com', 'PURCHASE_COMPLETE', 'Martina Alexandra Benalcázar Mena', 'martinabenal@hotmail.com', '5930999024158', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-28T09:30:50'),
  ('RETO15D-julian09.jl@gmail.com', 'PURCHASE_COMPLETE', 'Julian Lozano', 'julian09.jl@gmail.com', '573188089121', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T10:04:35'),
  ('RETO15D-michellemoav@hotmail.com', 'PURCHASE_COMPLETE', 'Michelle Molina Avendaño', 'michellemoav@hotmail.com', '525634512418', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-02-28T10:17:03'),
  ('RETO15D-juancamilomosari@gmail.com', 'PURCHASE_COMPLETE', 'Juan Mosquera', 'juancamilomosari@gmail.com', '573163204123', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T10:45:46'),
  ('RETO15D-gabrimora21@gmail.com', 'PURCHASE_COMPLETE', 'Gabriela Mora', 'gabrimora21@gmail.com', '573132971150', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T10:52:45'),
  ('RETO15D-melyocampo06@hotmail.com', 'PURCHASE_COMPLETE', 'Melissa Ocampo', 'melyocampo06@hotmail.com', '19542031321', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-02-28T11:14:53'),
  ('RETO15D-somosmarketingam@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra martinez jaramillo', 'somosmarketingam@gmail.com', '573186705201', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T12:22:37'),
  ('RETO15D-colorclick2014@gmail.com', 'PURCHASE_COMPLETE', 'andrea gonzalez', 'colorclick2014@gmail.com', '573154991099', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T12:41:12'),
  ('RETO15D-katherin4280@hotmail.com', 'PURCHASE_COMPLETE', 'katherin pastor pulgarin', 'katherin4280@hotmail.com', '573104360167', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T12:49:39'),
  ('RETO15D-vaneporti2@gmail.com', 'PURCHASE_COMPLETE', 'Vanessa Portilla Correa', 'vaneporti2@gmail.com', '573152525960', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T13:56:38'),
  ('RETO15D-decokidscuadritosconamor@gmail.com', 'PURCHASE_COMPLETE', 'Nataly monsalve', 'decokidscuadritosconamor@gmail.com', '573147316061', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T13:52:59'),
  ('RETO15D-sailyscardenasm@hotmail.com', 'PURCHASE_COMPLETE', 'Sailys Cardenas mercado', 'sailyscardenasm@hotmail.com', '573218747274', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T17:35:13'),
  ('RETO15D-solutececommerce@gmail.com', 'PURCHASE_COMPLETE', 'José Ramirez', 'solutececommerce@gmail.com', '573132159136', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T18:12:41'),
  ('RETO15D-solmarianagranadosvargas@gmail.com', 'PURCHASE_COMPLETE', 'Sol Mariana Granados Vargas', 'solmarianagranadosvargas@gmail.com', '573202691366', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T19:51:52'),
  ('RETO15D-morenocorreadk@gmail.com', 'PURCHASE_COMPLETE', 'Edilson Fernando Moreno Correa', 'morenocorreadk@gmail.com', '573162523174', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T20:21:40'),
  ('RETO15D-jpbustamante20@outlook.com', 'PURCHASE_COMPLETE', 'Juan Pablo Bustamante', 'jpbustamante20@outlook.com', '573152116931', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-02-28T22:11:09'),
  ('RETO15D-iveenaranjo@gmail.com', 'PURCHASE_COMPLETE', 'Ivonne Naranjo', 'iveenaranjo@gmail.com', '5930958747727', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-01T06:25:19'),
  ('RETO15D-alexandra_14533669@hotmail.com', 'PURCHASE_COMPLETE', 'alexandra gonzalez', 'alexandra_14533669@hotmail.com', '573123142411', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-01T07:23:02'),
  ('RETO15D-marcelamacias2016@gmail.com', 'PURCHASE_COMPLETE', 'Marcela macias', 'marcelamacias2016@gmail.com', '573004340895', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-01T08:10:16'),
  ('RETO15D-cliosocialescan@gmail.com', 'PURCHASE_COMPLETE', 'Paty Barón', 'cliosocialescan@gmail.com', '573208028294', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-01T09:12:21'),
  ('RETO15D-jhanpineda24@gmail.com', 'PURCHASE_COMPLETE', 'jhan carlos pineda morales', 'jhanpineda24@gmail.com', '573103515780', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-01T10:01:45'),
  ('RETO15D-hernandezyasmely@gmail.com', 'PURCHASE_COMPLETE', 'Yasmely Hernandez', 'hernandezyasmely@gmail.com', '117867095813', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-01T10:02:00'),
  ('RETO15D-daohe16@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Osorio Henao', 'daohe16@gmail.com', '117869393335', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-01T10:54:02'),
  ('RETO15D-foixcar@gmail.com', 'PURCHASE_COMPLETE', 'Jose Hali', 'foixcar@gmail.com', '543815438868', 'AR', 'Reto 15D', 38.34, 'USD', 'active', '2025-03-01T15:35:52'),
  ('RETO15D-melisagiraldo.ai@gmail.com', 'PURCHASE_COMPLETE', 'MELISA GIRALDO', 'melisagiraldo.ai@gmail.com', '573215674512', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-01T17:02:10'),
  ('RETO15D-mennarcompras@hotmail.com', 'PURCHASE_COMPLETE', 'William muñoz', 'mennarcompras@hotmail.com', '573116315342', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-01T18:30:16'),
  ('RETO15D-info@jhonnvesga.com', 'PURCHASE_COMPLETE', 'Jhonn Vesga', 'info@jhonnvesga.com', '573203435164', 'CO', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-01T19:34:39'),
  ('RETO15D-virgicordeiro@gmail.com', 'PURCHASE_COMPLETE', 'Virginia Cordeiro', 'virgicordeiro@gmail.com', '598092557501', 'UY', 'Reto 15D', 36.94, 'USD', 'active', '2025-03-02T07:31:50'),
  ('RETO15D-maricleir2@gmail.com', 'PURCHASE_COMPLETE', 'maria claudia granados valenzuela', 'maricleir2@gmail.com', '573045709355', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T07:56:47'),
  ('RETO15D-jeniffervente.publicidad@gmail.com', 'PURCHASE_COMPLETE', 'Jeniffer Venté', 'jeniffervente.publicidad@gmail.com', '573182714899', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T09:26:53'),
  ('RETO15D-tiendalunabymarisol@gmail.com', 'PURCHASE_COMPLETE', 'Marisol Luna cano', 'tiendalunabymarisol@gmail.com', '522297689627', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T11:03:15'),
  ('RETO15D-alejandra.parraq04@gmail.com', 'PURCHASE_COMPLETE', 'Maria alejandra parra quevedo', 'alejandra.parraq04@gmail.com', '573027199492', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-02T12:00:01'),
  ('RETO15D-dasha.planticas@gmail.com', 'PURCHASE_COMPLETE', 'Diana Gama', 'dasha.planticas@gmail.com', '573182658995', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T11:59:16'),
  ('RETO15D-marcelsalazar80@hotmail.com', 'PURCHASE_COMPLETE', 'Marcel Salazar', 'marcelsalazar80@hotmail.com', '573176491303', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T15:08:28'),
  ('RETO15D-misabel_rivera@hotmail.com', 'PURCHASE_COMPLETE', 'María Isabel Rivera', 'misabel_rivera@hotmail.com', '573208533957', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-02T15:14:19'),
  ('RETO15D-leidy.4491@gmail.com', 'PURCHASE_COMPLETE', 'Leidy Johanna Agudelo Arango', 'leidy.4491@gmail.com', '573002329908', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T15:26:58'),
  ('RETO15D-loamylobo656@gmail.com', 'PURCHASE_COMPLETE', 'Ruth loamy', 'loamylobo656@gmail.com', '17732691775', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-02T16:37:44'),
  ('RETO15D-intluiscorrea@gmail.com', 'PURCHASE_COMPLETE', 'LUIS CARMELO CORREA MIRANDA', 'intluiscorrea@gmail.com', '573016897361', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-02T18:08:30'),
  ('RETO15D-clarainesaristizabal0421@gmail.com', 'PURCHASE_COMPLETE', 'Clara Inés', 'clarainesaristizabal0421@gmail.com', '573015514252', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T19:00:14'),
  ('RETO15D-diegogz.2709@gmail.com', 'PURCHASE_COMPLETE', 'Diego Garcia', 'diegogz.2709@gmail.com', '573102986437', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T20:40:20'),
  ('RETO15D-maria.francho@hotmail.com', 'PURCHASE_COMPLETE', 'Maria del mar franco Gaviria', 'maria.francho@hotmail.com', '573113049406', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T22:28:44'),
  ('RETO15D-racast163043@gmail.com', 'PURCHASE_COMPLETE', 'Rafael Castellanos', 'racast163043@gmail.com', '19197440877', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-02T22:35:22'),
  ('RETO15D-fabio157maje@gmail.com', 'PURCHASE_COMPLETE', 'Fabio Maje', 'fabio157maje@gmail.com', '573105802161', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-02T23:11:45'),
  ('RETO15D-camilavelasquez721@gmail.com', 'PURCHASE_COMPLETE', 'Maria camila velasquez', 'camilavelasquez721@gmail.com', '573005411725', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T00:03:35'),
  ('RETO15D-juantorres2589@gmail.com', 'PURCHASE_COMPLETE', 'Juan Manuel Torres', 'juantorres2589@gmail.com', '50761548819', 'PA', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T12:17:15'),
  ('RETO15D-alex.28.92@icloud.com', 'PURCHASE_COMPLETE', 'Jhoan Alejandro Gil', 'alex.28.92@icloud.com', '14073424490', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-03T12:48:30'),
  ('RETO15D-camiloaguirre1806@gmail.com', 'PURCHASE_COMPLETE', 'Camilo Aguirre Vargas', 'camiloaguirre1806@gmail.com', '573133406497', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T15:44:03'),
  ('RETO15D-floryreyes2090@gmail.com', 'PURCHASE_COMPLETE', 'Florencia Reyes', 'floryreyes2090@gmail.com', '13476545576', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-03T16:04:52'),
  ('RETO15D-miguelfotos162@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Rivera', 'miguelfotos162@gmail.com', '525536700983', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-03-03T17:51:04'),
  ('RETO15D-leidymarcelamedinasanchez@hotmail.com', 'PURCHASE_COMPLETE', 'leidy marcela medina sanchez', 'leidymarcelamedinasanchez@hotmail.com', '573205953863', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T17:51:35'),
  ('RETO15D-nicolarango20@hotmail.com', 'PURCHASE_COMPLETE', 'Nicol Arango', 'nicolarango20@hotmail.com', '573185904871', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T18:17:57'),
  ('RETO15D-bigpotentialmarketing@gmail.com', 'PURCHASE_COMPLETE', 'Diego Gómez', 'bigpotentialmarketing@gmail.com', '573014308618', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T18:19:30'),
  ('RETO15D-katerineareiza75@gmail.com', 'PURCHASE_COMPLETE', 'Katerine areiza', 'katerineareiza75@gmail.com', '573215147509', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T19:28:00'),
  ('RETO15D-storedn20@gmail.com', 'PURCHASE_COMPLETE', 'Jerson Giovanny Diaz Gonzalez', 'storedn20@gmail.com', '573138303965', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-03T20:29:23'),
  ('RETO15D-sjuan7709@gmail.com', 'PURCHASE_COMPLETE', 'Camilo Sanchez', 'sjuan7709@gmail.com', '113853844502', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-03T21:52:43'),
  ('RETO15D-lmbv15011979@gmail.com', 'PURCHASE_COMPLETE', 'Luz Marina Bravo', 'lmbv15011979@gmail.com', '573216037375', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T06:40:02'),
  ('RETO15D-microcapilart@gmail.com', 'PURCHASE_COMPLETE', 'Juan Manuel Hernandez Molina', 'microcapilart@gmail.com', '573002177899', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T07:21:16'),
  ('RETO15D-salgueroca@hotmail.com', 'PURCHASE_COMPLETE', 'Cesar Salguero Castañeda', 'salgueroca@hotmail.com', '573185562483', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T07:49:28'),
  ('RETO15D-dk96@outlook.com', 'PURCHASE_COMPLETE', 'Andres Erraez', 'dk96@outlook.com', '593984348441', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-04T08:15:19'),
  ('RETO15D-zuluagaanduquiamayradaniela@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Zuluaga', 'zuluagaanduquiamayradaniela@gmail.com', '573205866668', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T08:20:16'),
  ('RETO15D-anacsf96@gmail.com', 'PURCHASE_COMPLETE', 'ANA CAROLINA SEPULVEDA', 'anacsf96@gmail.com', '573184924524', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T08:50:21'),
  ('RETO15D-wrcomercioelectronico@gmail.com', 'PURCHASE_COMPLETE', 'Wylliam Alfredo Restrepo Diago', 'wrcomercioelectronico@gmail.com', '573184356344', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T09:10:40'),
  ('RETO15D-camigar808@gmail.com', 'PURCHASE_COMPLETE', 'Naren Camilo García', 'camigar808@gmail.com', '573154510292', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T09:29:46'),
  ('RETO15D-jholman314@gmail.com', 'PURCHASE_COMPLETE', 'Jholman Henao', 'jholman314@gmail.com', '573161001189', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T10:18:51'),
  ('RETO15D-argeliachasan@gmail.com', 'PURCHASE_COMPLETE', 'Argelia Chacón Sánchez', 'argeliachasan@gmail.com', '522224305494', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-03-04T11:18:38'),
  ('RETO15D-menichinismart@gmail.com', 'PURCHASE_COMPLETE', 'Arianna Menichini', 'menichinismart@gmail.com', '18017921542', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-04T11:22:19'),
  ('RETO15D-liiscoar@hotmail.com', 'PURCHASE_COMPLETE', 'Isabel Corzo', 'liiscoar@hotmail.com', '573112350885', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T11:50:17'),
  ('RETO15D-vivicolorsmake.up@gmail.com', 'PURCHASE_COMPLETE', 'Viviana Suarez', 'vivicolorsmake.up@gmail.com', '117863390924', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-04T12:17:42'),
  ('RETO15D-karendell96@hotmail.com', 'PURCHASE_COMPLETE', 'Karen Dell Tejada', 'karendell96@hotmail.com', '573203273626', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T13:42:42'),
  ('RETO15D-derlyholpaez89@gmail.com', 'PURCHASE_COMPLETE', 'Derly yineth holguin', 'derlyholpaez89@gmail.com', '573213896613', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T15:06:31'),
  ('RETO15D-davasu88@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Valencia', 'davasu88@gmail.com', '573113711347', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T17:04:52'),
  ('RETO15D-ricardoggoenaga@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo alberto gOnzalez Goenaga', 'ricardoggoenaga@gmail.com', '524431374486', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-03-04T17:33:33'),
  ('RETO15D-etowersit@gmail.com', 'PURCHASE_COMPLETE', 'Edgar Ulises Torres Manzano', 'etowersit@gmail.com', '525516960814', 'MX', 'Reto 15D', 37.03, 'USD', 'active', '2025-03-04T17:42:36'),
  ('RETO15D-patymatikas@gmail.com', 'PURCHASE_COMPLETE', 'Patricia Espinel', 'patymatikas@gmail.com', '573186448481', 'CO', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-04T19:06:16'),
  ('RETO15D-pierpulido@gmail.com', 'PURCHASE_COMPLETE', 'pier paulo pulido perez', 'pierpulido@gmail.com', '573003295241', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T20:04:25'),
  ('RETO15D-delarosacreativos@gmail.com', 'PURCHASE_COMPLETE', 'Abisays Elias Moreno C.', 'delarosacreativos@gmail.com', '573013854186', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T20:51:27'),
  ('RETO15D-loyolaovallema@gmail.com', 'PURCHASE_COMPLETE', 'Maira Loyola', 'loyolaovallema@gmail.com', '17862800147', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-04T20:53:26'),
  ('RETO15D-paomylepr@gmail.com', 'PURCHASE_COMPLETE', 'Paola Ruiz', 'paomylepr@gmail.com', '573046615123', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T21:01:12'),
  ('RETO15D-santo-357@hotmail.com', 'PURCHASE_COMPLETE', 'James Aristizabal', 'santo-357@hotmail.com', '573232263758', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T21:17:30'),
  ('RETO15D-cflorezpinilla@gmail.com', 'PURCHASE_COMPLETE', 'CAROL JOHANNA FLOREZ PINILLA', 'cflorezpinilla@gmail.com', '573123443726', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T22:52:07'),
  ('RETO15D-sergiogg200404@gmail.com', 'PURCHASE_COMPLETE', 'Sergio Gaitan Guerrero', 'sergiogg200404@gmail.com', '573212545596', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-04T23:19:41'),
  ('RETO15D-esperanza733@hotmail.com', 'PURCHASE_COMPLETE', 'Diana Esperanza Páez Arias', 'esperanza733@hotmail.com', '573114420337', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T05:47:07'),
  ('RETO15D-catarias.81@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Catalina Arias arango', 'catarias.81@gmail.com', '573104539226', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T07:07:18'),
  ('RETO15D-jeco23@hotmail.com', 'PURCHASE_COMPLETE', 'Jeferson Correa', 'jeco23@hotmail.com', '573135941800', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T07:25:00'),
  ('RETO15D-yulicasfra@gmail.com', 'PURCHASE_COMPLETE', 'Yuliana Castro Franco', 'yulicasfra@gmail.com', '573046787143', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-05T08:36:15'),
  ('RETO15D-priscyg@gmail.com', 'PURCHASE_COMPLETE', 'Priscila G', 'priscyg@gmail.com', '523111591726', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-03-05T09:41:26'),
  ('RETO15D-camilach.25@outlook.com', 'PURCHASE_COMPLETE', 'Camila chavista', 'camilach.25@outlook.com', '573123691286', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T10:20:02'),
  ('RETO15D-cristian09giraldo@gmail.com', 'PURCHASE_COMPLETE', 'Cristian Serna Giraldo', 'cristian09giraldo@gmail.com', '573044437837', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T12:50:28'),
  ('RETO15D-mariafonnegra11@gmail.com', 'PURCHASE_COMPLETE', 'Maria Jisnedy Salazar Fonnegra', 'mariafonnegra11@gmail.com', '573226475836', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T15:57:56'),
  ('RETO15D-tacasaurio@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Angel Tamayo cano', 'tacasaurio@gmail.com', '573224967727', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T16:05:57'),
  ('RETO15D-elmundodelaplatachile@gmail.com', 'PURCHASE_COMPLETE', 'Gloria Garcia', 'elmundodelaplatachile@gmail.com', '56966486330', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T17:46:14'),
  ('RETO15D-mafe_andrade@hotmail.com', 'PURCHASE_COMPLETE', 'fernanda andrade', 'mafe_andrade@hotmail.com', '593985828434', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-05T19:35:04'),
  ('RETO15D-melgarejo07@hotmail.com', 'PURCHASE_COMPLETE', 'Edwin Suarez', 'melgarejo07@hotmail.com', '573006321297', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-05T19:58:40'),
  ('RETO15D-ivalencia29@hotmail.com', 'PURCHASE_COMPLETE', 'amanda Isabel Valencia', 'ivalencia29@hotmail.com', '50762658780', 'PA', 'Reto 15D', 37.05, 'USD', 'active', '2025-03-06T07:39:06'),
  ('RETO15D-andreabriceno_15@hotmail.com', 'PURCHASE_COMPLETE', 'Jenny Andrea briceno', 'andreabriceno_15@hotmail.com', '573107645047', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T07:58:54'),
  ('RETO15D-lilivel87@hotmail.com', 'PURCHASE_COMPLETE', 'Liliana Velasquez García', 'lilivel87@hotmail.com', '573128697335', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-06T07:59:26'),
  ('RETO15D-lissethmarcela1@gmail.com', 'PURCHASE_COMPLETE', 'Lisseth Marcela Álvarez Muentes', 'lissethmarcela1@gmail.com', '573004326851', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-06T08:27:36'),
  ('RETO15D-mapug.educacion@gmail.com', 'PURCHASE_COMPLETE', 'Maira Puerta', 'mapug.educacion@gmail.com', '573213446990', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T08:36:22'),
  ('RETO15D-emreyesq@gmail.com', 'PURCHASE_COMPLETE', 'Erica Marcela Reyes Quebrada', 'emreyesq@gmail.com', '573013722960', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T09:18:25'),
  ('RETO15D-meneses.co@softmix.click', 'PURCHASE_COMPLETE', 'Felipe Meneses', 'meneses.co@softmix.click', '573197292019', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T13:25:20'),
  ('RETO15D-dracarlacardenas@gmail.com', 'PURCHASE_COMPLETE', 'Carla Cardenas', 'dracarlacardenas@gmail.com', '573117154540', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T14:16:11'),
  ('RETO15D-iskralanducci96@gmail.com', 'PURCHASE_COMPLETE', 'Iskra landucci', 'iskralanducci96@gmail.com', '593987652024', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-06T15:54:23'),
  ('RETO15D-andres.sosa01@hotmail.com', 'PURCHASE_COMPLETE', 'Zamir andres sosa parra', 'andres.sosa01@hotmail.com', '573177427483', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T16:02:30'),
  ('RETO15D-cgstudiove@gmail.com', 'PURCHASE_COMPLETE', 'Diana Granado', 'cgstudiove@gmail.com', '13233026458', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-06T16:21:55'),
  ('RETO15D-catherine.baronc@gmail.com', 'PURCHASE_COMPLETE', 'Catherine Baron', 'catherine.baronc@gmail.com', '573107722910', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T16:55:58'),
  ('RETO15D-yralisbetancourt70@gmail.com', 'PURCHASE_COMPLETE', 'Yralis Hayde Betancourt Guevara', 'yralisbetancourt70@gmail.com', '573188242555', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T17:02:09'),
  ('RETO15D-akire1784@hotmail.com', 'PURCHASE_COMPLETE', 'Erika sepulveda', 'akire1784@hotmail.com', '573182224055', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-06T19:37:58'),
  ('RETO15D-angieepa19@gmail.com', 'PURCHASE_COMPLETE', 'Angie duque', 'angieepa19@gmail.com', '584149013371', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-06T23:00:56'),
  ('RETO15D-angelaordonez1234@gmail.com', 'PURCHASE_COMPLETE', 'Luz Rodríguez', 'angelaordonez1234@gmail.com', '573016223159', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T04:42:16'),
  ('RETO15D-lindawongvillacis@yahoo.es', 'PURCHASE_COMPLETE', 'Linda Wong Villacis', 'lindawongvillacis@yahoo.es', '5930993007799', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-07T06:31:53'),
  ('RETO15D-karenfuxion24@gmail.com', 'PURCHASE_COMPLETE', 'Karen ochoa', 'karenfuxion24@gmail.com', '573504946866', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T07:14:09'),
  ('RETO15D-maye.t.gomez@hotmail.com', 'PURCHASE_COMPLETE', 'Mayerly torres', 'maye.t.gomez@hotmail.com', '573168778369', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T07:26:53'),
  ('RETO15D-marypatry54@hotmail.com', 'PURCHASE_COMPLETE', 'María Patricia Candanoza', 'marypatry54@hotmail.com', '573008116511', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T07:38:16'),
  ('RETO15D-gonzalez.jek@gmail.com', 'PURCHASE_COMPLETE', 'Jessika González', 'gonzalez.jek@gmail.com', '573044933927', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T09:51:02'),
  ('RETO15D-robertojose032019@gmail.com', 'PURCHASE_COMPLETE', 'Roberto Jose Suarez Mejia', 'robertojose032019@gmail.com', '573002691723', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T10:30:40'),
  ('RETO15D-carlosfabianrojas10@hotmail.com', 'PURCHASE_COMPLETE', 'Carlos fabian Rojas bocanegra', 'carlosfabianrojas10@hotmail.com', '573132827582', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T11:57:41'),
  ('RETO15D-limalemu@gmail.com', 'PURCHASE_COMPLETE', 'Lina Marcela Leal Murgas', 'limalemu@gmail.com', '573226799338', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T12:02:26'),
  ('RETO15D-fragancee8@gmail.com', 'PURCHASE_COMPLETE', 'Maria fernanda hernandez', 'fragancee8@gmail.com', '573104065887', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T17:35:17'),
  ('RETO15D-yuriprojas@yahoo.es', 'PURCHASE_COMPLETE', 'Yuri Rojas', 'yuriprojas@yahoo.es', '573202834075', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T17:45:29'),
  ('RETO15D-mxzonestore@gmail.com', 'PURCHASE_COMPLETE', 'mx zone store', 'mxzonestore@gmail.com', '573135060224', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T18:01:04'),
  ('RETO15D-andresfella@hotmail.com', 'PURCHASE_COMPLETE', 'Andres Felipe Llanos Suarez', 'andresfella@hotmail.com', '573184001306', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T18:09:48'),
  ('RETO15D-carolina.blanco@velawhite.com', 'PURCHASE_COMPLETE', 'Carolina Blanco', 'carolina.blanco@velawhite.com', '51999962140', 'PE', 'Reto 15D', 35.99, 'USD', 'active', '2025-03-07T18:33:48'),
  ('RETO15D-ricardopinilla9@hotmail.com', 'PURCHASE_COMPLETE', 'Ricardo Pinilla', 'ricardopinilla9@hotmail.com', '573113931989', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T19:04:31'),
  ('RETO15D-jjairo171@gmail.com', 'PURCHASE_COMPLETE', 'jhon jairo Nuñez peña', 'jjairo171@gmail.com', '573007947693', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T19:11:02'),
  ('RETO15D-studiolombaitcorp@gmail.com', 'PURCHASE_COMPLETE', 'Natasha figueroa', 'studiolombaitcorp@gmail.com', '13054145555', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-07T19:14:21'),
  ('RETO15D-wilopupilo@gmail.com', 'PURCHASE_COMPLETE', 'Wiliam Mera', 'wilopupilo@gmail.com', '573143220373', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T20:16:12'),
  ('RETO15D-carolinarueda1608@gmail.com', 'PURCHASE_COMPLETE', 'Carolina Bolívar', 'carolinarueda1608@gmail.com', '573208402192', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T20:18:12'),
  ('RETO15D-lgjohana10@gmail.com', 'PURCHASE_COMPLETE', 'Johana londoño', 'lgjohana10@gmail.com', '573147501873', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T22:34:20'),
  ('RETO15D-guzceballos1@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Ceballos', 'guzceballos1@gmail.com', '573104570757', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-07T23:22:16'),
  ('RETO15D-patosandy2711@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Monroy', 'patosandy2711@gmail.com', '17869702343', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T06:11:26'),
  ('RETO15D-mardiazin@gmail.com', 'PURCHASE_COMPLETE', 'Mar Díaz Rodriguez', 'mardiazin@gmail.com', '573137114295', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-08T06:26:08'),
  ('RETO15D-soniavera38@gmail.com', 'PURCHASE_COMPLETE', 'Sonia vera', 'soniavera38@gmail.com', '18562364412', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T08:35:01'),
  ('RETO15D-laucanina@outlook.com', 'PURCHASE_COMPLETE', 'Raul Lozano alvernia', 'laucanina@outlook.com', '573112411509', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-08T08:29:41'),
  ('RETO15D-shepard.ohonsi.sob@gmail.com', 'PURCHASE_COMPLETE', 'Shepard ohonsi', 'shepard.ohonsi.sob@gmail.com', '51974132764', 'PE', 'Reto 15D', 37.03, 'USD', 'active', '2025-03-08T08:54:50'),
  ('RETO15D-zullyalejandra@gmail.com', 'PURCHASE_COMPLETE', 'ZULLY A RUEDA E', 'zullyalejandra@gmail.com', '573012753968', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-08T11:49:13'),
  ('RETO15D-addys2353@gmail.com', 'PURCHASE_COMPLETE', 'ADDYS PARRA CRUZ', 'addys2353@gmail.com', '593992503573', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T13:17:22'),
  ('RETO15D-danielaospinarmodel@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Ospina Ríos', 'danielaospinarmodel@gmail.com', '573147108538', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-08T13:36:42'),
  ('RETO15D-leidymillan23@gmail.com', 'PURCHASE_COMPLETE', 'Leidy Millan', 'leidymillan23@gmail.com', '13054406852', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T14:05:22'),
  ('RETO15D-daniroman27@hotmail.com', 'PURCHASE_COMPLETE', 'Daniela Roman', 'daniroman27@hotmail.com', '573507844600', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-08T18:48:50'),
  ('RETO15D-nana_saldarriaga@hotmail.com', 'PURCHASE_COMPLETE', 'Nana Saldarriaga', 'nana_saldarriaga@hotmail.com', '18134361044', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T20:39:46'),
  ('RETO15D-gerencia.idh@gmail.com', 'PURCHASE_COMPLETE', 'Guillermo Molina González', 'gerencia.idh@gmail.com', '573005064359', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-08T20:53:55'),
  ('RETO15D-nunezyasira88@gmail.com', 'PURCHASE_COMPLETE', 'Yasira nunez', 'nunezyasira88@gmail.com', '16318301447', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T22:17:00'),
  ('RETO15D-gutierrezclady@gmail.com', 'PURCHASE_COMPLETE', 'Lady Gutiérrez', 'gutierrezclady@gmail.com', '50765078176', 'PA', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-08T23:14:36'),
  ('RETO15D-amorenoc100@yahoo.es', 'PURCHASE_COMPLETE', 'luz Ángela moreno', 'amorenoc100@yahoo.es', '34604261898', 'ES', 'Reto 15D', 36.84, 'USD', 'active', '2025-03-09T06:30:43'),
  ('RETO15D-cursos@markiany.com', 'PURCHASE_COMPLETE', 'Marcos Calvo Arroyo', 'cursos@markiany.com', '112148081885', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-09T07:56:48'),
  ('RETO15D-mpiedrahitagutierrez@gmail.com', 'PURCHASE_COMPLETE', 'Maria alejandra piedrahita', 'mpiedrahitagutierrez@gmail.com', '573105463555', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-09T08:35:34'),
  ('RETO15D-jjcolorador@gmail.com', 'PURCHASE_COMPLETE', 'Juan José', 'jjcolorador@gmail.com', '573246859545', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T08:58:57'),
  ('RETO15D-pepitoperez007@protonmail.com', 'PURCHASE_COMPLETE', 'Pedro Perez', 'pepitoperez007@protonmail.com', '573123578965', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T09:05:50'),
  ('RETO15D-pangeabeer@gmail.com', 'PURCHASE_COMPLETE', 'Oscar Quiñones niño', 'pangeabeer@gmail.com', '573152933968', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T09:06:06'),
  ('RETO15D-linalotteart@gmail.com', 'PURCHASE_COMPLETE', 'Caro Montenegro', 'linalotteart@gmail.com', '5930989728510', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-09T09:55:26'),
  ('RETO15D-bajosusalasarte@gmail.com', 'PURCHASE_COMPLETE', 'Jessica Arenas', 'bajosusalasarte@gmail.com', '573146786217', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T10:37:43'),
  ('RETO15D-familiaalexaspa@gmail.com', 'PURCHASE_COMPLETE', 'Alexandra Torres Valencia', 'familiaalexaspa@gmail.com', '573146020071', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T10:59:32'),
  ('RETO15D-dramosyarleque@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Ramos', 'dramosyarleque@gmail.com', '51995869109', 'PE', 'Reto 15D', 37.46, 'USD', 'active', '2025-03-09T11:42:59'),
  ('RETO15D-pipe_duque@hotmail.com', 'PURCHASE_COMPLETE', 'Andres Felipe Duque Restrepo', 'pipe_duque@hotmail.com', '573187099189', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T13:03:08'),
  ('RETO15D-deyarubio@gmail.com', 'PURCHASE_COMPLETE', 'Deyanira Rubio', 'deyarubio@gmail.com', '524422502571', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-09T16:25:51'),
  ('RETO15D-blendysramos@gmail.com', 'PURCHASE_COMPLETE', 'BLENDYS RAMOS', 'blendysramos@gmail.com', '573008860840', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T17:38:57'),
  ('RETO15D-prisvivarv@gmail.com', 'PURCHASE_COMPLETE', 'Priscila Vivar', 'prisvivarv@gmail.com', '5930987666552', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-09T19:28:23'),
  ('RETO15D-isahh25@gmail.com', 'PURCHASE_COMPLETE', 'Isabela Hoyos Hoyos', 'isahh25@gmail.com', '573183897932', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T20:45:43'),
  ('RETO15D-remolinaalbert@gmail.com', 'PURCHASE_COMPLETE', 'Albert Remolina', 'remolinaalbert@gmail.com', '573128706400', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-09T22:25:39'),
  ('RETO15D-mazzarelli2017@gmail.com', 'PURCHASE_COMPLETE', 'Gian Mazzarelli', 'mazzarelli2017@gmail.com', '56973463015', 'CL', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-09T23:20:49'),
  ('RETO15D-giovanni.alf.mar@gmail.com', 'PURCHASE_COMPLETE', 'Giovanni Martina', 'giovanni.alf.mar@gmail.com', '51926907148', 'PE', 'Reto 15D', 37.45, 'USD', 'active', '2025-03-10T00:31:28'),
  ('RETO15D-gabo71136244@gmail.com', 'PURCHASE_COMPLETE', 'Gabriel Rodríguez', 'gabo71136244@gmail.com', '5930995686032', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-10T05:46:02'),
  ('RETO15D-bibianita12@hotmail.com', 'PURCHASE_COMPLETE', 'BIBIANA GAVIRIA T', 'bibianita12@hotmail.com', '573235801627', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T06:26:39'),
  ('RETO15D-harrymdigital@outlook.com', 'PURCHASE_COMPLETE', 'Harry Moreno', 'harrymdigital@outlook.com', '573164090984', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T06:31:37'),
  ('RETO15D-marcelastefany9@gmail.com', 'PURCHASE_COMPLETE', 'marcela perez mesa', 'marcelastefany9@gmail.com', '573192401803', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T07:15:29'),
  ('RETO15D-holy.interiorfemenino@gmail.com', 'PURCHASE_COMPLETE', 'Norma Cristina Pérez Hurtado', 'holy.interiorfemenino@gmail.com', '573206725147', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T08:03:19'),
  ('RETO15D-xiomyhenao18@hotmail.es', 'PURCHASE_COMPLETE', 'Xiomara Henao', 'xiomyhenao18@hotmail.es', '573104043527', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T08:30:22'),
  ('RETO15D-lilipod12@hotmail.com', 'PURCHASE_COMPLETE', 'jeancob tavera', 'lilipod12@hotmail.com', '573223318752', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-10T08:39:38'),
  ('RETO15D-lpablo59@gmail.com', 'PURCHASE_COMPLETE', 'Pablo David León Curimilma', 'lpablo59@gmail.com', '5930995331834', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-10T09:28:03'),
  ('RETO15D-pilotoguerrero281@gmail.com', 'PURCHASE_COMPLETE', 'Daniel felipe Guerrero Montilla', 'pilotoguerrero281@gmail.com', '573124910138', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T09:34:39'),
  ('RETO15D-infolizhernandez@gmail.com', 'PURCHASE_COMPLETE', 'lyceth Paola Bustos Hernandez', 'infolizhernandez@gmail.com', '573058606706', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T10:11:35'),
  ('RETO15D-christianleoval@hotmail.com', 'PURCHASE_COMPLETE', 'Christian Christian Valencia', 'christianleoval@hotmail.com', '573207932056', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T11:40:00'),
  ('RETO15D-carolina.tabarez.ct@gmail.com', 'PURCHASE_COMPLETE', 'Caro Tabarez', 'carolina.tabarez.ct@gmail.com', '573206890430', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T13:38:13'),
  ('RETO15D-mad6812@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Angel Delgado', 'mad6812@gmail.com', '573025315565', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T15:19:54'),
  ('RETO15D-infomeliospinacocinacocina@gmail.com', 'PURCHASE_COMPLETE', 'Meli Ospina', 'infomeliospinacocinacocina@gmail.com', '573216394990', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T15:43:54'),
  ('RETO15D-csmafra@gmail.com', 'PURCHASE_COMPLETE', 'Marisol Ortega Franco', 'csmafra@gmail.com', '573015463548', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-10T22:15:08'),
  ('RETO15D-qdenisse@gmail.com', 'PURCHASE_COMPLETE', 'DENISSE MICHELLE QUIMI CAICEDO', 'qdenisse@gmail.com', '5930984934039', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-10T23:14:21'),
  ('RETO15D-velagiraldo@gmail.com', 'PURCHASE_COMPLETE', 'Lina Marcela Vela Giraldo', 'velagiraldo@gmail.com', '573017713126', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-11T11:46:33'),
  ('RETO15D-pattylunadr@gmail.com', 'PURCHASE_COMPLETE', 'Elsa Patricia Luna', 'pattylunadr@gmail.com', '526441551474', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-03-11T13:05:26'),
  ('RETO15D-katelonga@hotmail.com', 'PURCHASE_COMPLETE', 'Katherine Longa', 'katelonga@hotmail.com', '573219041876', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-11T13:44:16'),
  ('RETO15D-docabreras.pe@gmail.com', 'PURCHASE_COMPLETE', 'Victor Cabrera', 'docabreras.pe@gmail.com', '51946951327', 'PE', 'Reto 15D', 37.44, 'USD', 'active', '2025-03-11T15:45:57'),
  ('RETO15D-jess0235marketing@gmail.com', 'PURCHASE_COMPLETE', 'Jessica barroeta', 'jess0235marketing@gmail.com', '17864062199', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-11T15:53:02'),
  ('RETO15D-andrewzerva0903@gmail.com', 'PURCHASE_COMPLETE', 'Andres Eduardo Cervantes Diaz', 'andrewzerva0903@gmail.com', '584142661285', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-11T16:39:54'),
  ('RETO15D-mariana.valenciac@autonoma.edu.co', 'PURCHASE_COMPLETE', 'Mariana Valencia', 'mariana.valenciac@autonoma.edu.co', '573003208323', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-11T17:59:47'),
  ('RETO15D-johsef4dmrs@gmail.com', 'PURCHASE_COMPLETE', 'Johsef Palomino Cardos', 'johsef4dmrs@gmail.com', '529997470509', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-11T21:47:39'),
  ('RETO15D-zapataduberandres@gmail.com', 'PURCHASE_COMPLETE', 'Duber Andres Zapata', 'zapataduberandres@gmail.com', '573217664727', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-11T22:11:02'),
  ('RETO15D-sebastianlondonoj@gmail.com', 'PURCHASE_COMPLETE', 'Sebastian Londoño', 'sebastianlondonoj@gmail.com', '573002018657', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-11T22:20:21'),
  ('RETO15D-andresgiraldo325@gmail.com', 'PURCHASE_COMPLETE', 'Carlos andres Giraldo hernandez', 'andresgiraldo325@gmail.com', '573045827695', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-11T23:24:40'),
  ('RETO15D-hassel.ortegapelaez@gmail.com', 'PURCHASE_COMPLETE', 'Hassel Ortega pelaez', 'hassel.ortegapelaez@gmail.com', '525618356363', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-11T23:30:31'),
  ('RETO15D-jamerq.91@gmail.com', 'PURCHASE_COMPLETE', 'Jamer Quinchia Quinchia', 'jamerq.91@gmail.com', '573192267698', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-11T23:51:04'),
  ('RETO15D-brayangonzalesmejia321@gmail.com', 'PURCHASE_COMPLETE', 'Brayan Gonzalez', 'brayangonzalesmejia321@gmail.com', '573143184278', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T00:28:39'),
  ('RETO15D-perla_87743@hotmail.com', 'PURCHASE_COMPLETE', 'Perla Espinoza', 'perla_87743@hotmail.com', '19154714640', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-12T02:21:33'),
  ('RETO15D-germancorreamarin@gmail.com', 'PURCHASE_COMPLETE', 'German correa', 'germancorreamarin@gmail.com', '112013204883', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-12T07:19:58'),
  ('RETO15D-gcamachoh95@gmail.com', 'PURCHASE_COMPLETE', 'Guadalupe Camacho Hernández', 'gcamachoh95@gmail.com', '525540578082', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-12T08:02:32'),
  ('RETO15D-yureesly1981@gmail.com', 'PURCHASE_COMPLETE', 'Yureisly Fernández Castillo', 'yureesly1981@gmail.com', '5930984269194', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-12T09:32:13'),
  ('RETO15D-cardonacami29@gmail.com', 'PURCHASE_COMPLETE', 'Maria Camila Cardona Muñoz', 'cardonacami29@gmail.com', '573145258798', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T10:24:31'),
  ('RETO15D-pedropaucar37@gmail.com', 'PURCHASE_COMPLETE', 'Pedro paucar', 'pedropaucar37@gmail.com', '14435224294', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-12T12:59:35'),
  ('RETO15D-lissoexpresvip@gmail.com', 'PURCHASE_COMPLETE', 'Jenniffer Monroy', 'lissoexpresvip@gmail.com', '573158222233', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T13:38:07'),
  ('RETO15D-emprendeconalexa@gmail.com', 'PURCHASE_COMPLETE', 'Alexandra Milena Gonzalez Wilches', 'emprendeconalexa@gmail.com', '573173759486', 'CO', 'Reto 15D', 36.77, 'USD', 'active', '2025-03-12T15:42:52'),
  ('RETO15D-anndres903@gmail.com', 'PURCHASE_COMPLETE', 'Andres Amezquita', 'anndres903@gmail.com', '573208560816', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T17:06:21'),
  ('RETO15D-laagmvz@gmail.com', 'PURCHASE_COMPLETE', 'Luz Adriana Arenas', 'laagmvz@gmail.com', '573185902414', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T17:15:32'),
  ('RETO15D-dianapatriciaca@gmail.com', 'PURCHASE_COMPLETE', 'Diana Calle', 'dianapatriciaca@gmail.com', '5930969379408', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-12T17:45:59'),
  ('RETO15D-angel.aycardi@outlook.com', 'PURCHASE_COMPLETE', 'Angel Dario Aycardi Calume', 'angel.aycardi@outlook.com', '573127671232', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T20:46:26'),
  ('RETO15D-jamesvdigital@gmail.com', 'PURCHASE_COMPLETE', 'Jaime Ospina', 'jamesvdigital@gmail.com', '573023678870', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-12T23:04:56'),
  ('RETO15D-juanjo.0121@outlook.com', 'PURCHASE_COMPLETE', 'Juan José rojas', 'juanjo.0121@outlook.com', '573204366740', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-13T00:22:30'),
  ('RETO15D-dianatristancholache@gmail.com', 'PURCHASE_COMPLETE', 'Diana Tristancho', 'dianatristancholache@gmail.com', '573016740197', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T06:34:03'),
  ('RETO15D-nomadasdecorazontravel@gmail.com', 'PURCHASE_COMPLETE', 'Oscar Rodríguez', 'nomadasdecorazontravel@gmail.com', '573164178882', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-13T07:01:05'),
  ('RETO15D-sallymay08@hotmail.com', 'PURCHASE_COMPLETE', 'Sally May', 'sallymay08@hotmail.com', '573014262122', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T07:12:35'),
  ('RETO15D-diani.sierra@yahoo.com', 'PURCHASE_COMPLETE', 'Diana Sierra', 'diani.sierra@yahoo.com', '573017355195', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T08:00:28'),
  ('RETO15D-erikaplatas01@gmail.com', 'PURCHASE_COMPLETE', 'Erika Plata', 'erikaplatas01@gmail.com', '573123539334', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T08:05:43'),
  ('RETO15D-fafr81294@gmail.com', 'PURCHASE_COMPLETE', 'Francis Flores', 'fafr81294@gmail.com', '573028501418', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T08:15:12'),
  ('RETO15D-gabiuss25@hotmail.com', 'PURCHASE_COMPLETE', 'Gabriela Montenegro', 'gabiuss25@hotmail.com', '17187856099', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-13T08:39:34'),
  ('RETO15D-fabiolaandueza@gmail.com', 'PURCHASE_COMPLETE', 'Fabiola Andueza', 'fabiolaandueza@gmail.com', '573175690966', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T08:49:36'),
  ('RETO15D-adrianapramirezo@hotmail.com', 'PURCHASE_COMPLETE', 'ADRIANA RAMIREZ', 'adrianapramirezo@hotmail.com', '573133731993', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T09:57:23'),
  ('RETO15D-beatrizhernandezc1@gmail.com', 'PURCHASE_COMPLETE', 'Beatriz elena  Hernández Carmona', 'beatrizhernandezc1@gmail.com', '573137679165', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T10:06:57'),
  ('RETO15D-armoventas.atencion@gmail.com', 'PURCHASE_COMPLETE', 'Gilberto Ramírez Cervera', 'armoventas.atencion@gmail.com', '523316708073', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T11:07:28'),
  ('RETO15D-sayu.cantillo@gmail.com', 'PURCHASE_COMPLETE', 'sayurys cantillo', 'sayu.cantillo@gmail.com', '573015644493', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-13T12:00:19'),
  ('RETO15D-raquelramirez15@gmail.com', 'PURCHASE_COMPLETE', 'Raquel Ramírez', 'raquelramirez15@gmail.com', '573223115070', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T13:43:07'),
  ('RETO15D-2dfavilla@gmail.com', 'PURCHASE_COMPLETE', 'Diana Agudelo', '2dfavilla@gmail.com', '17185106076', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-13T15:05:17'),
  ('RETO15D-benja.flores.bta@gmail.com', 'PURCHASE_COMPLETE', 'Reynaldo benjamin flores bautista', 'benja.flores.bta@gmail.com', '527711297145', 'MX', 'Reto 15D', 37.07, 'USD', 'active', '2025-03-13T15:34:42'),
  ('RETO15D-lilianahl@icloud.com', 'PURCHASE_COMPLETE', 'LILIANA HERRERA', 'lilianahl@icloud.com', '573113411221', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T15:46:16'),
  ('RETO15D-jasipachano@gmail.com', 'PURCHASE_COMPLETE', 'Jassiell pachano', 'jasipachano@gmail.com', '573127482163', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T16:48:10'),
  ('RETO15D-fager777@gmail.com', 'PURCHASE_COMPLETE', 'Elizabeth Fager', 'fager777@gmail.com', '573192982963', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T17:49:00'),
  ('RETO15D-maribel.bellisima501@gmail.com', 'PURCHASE_COMPLETE', 'Maribel Alvarez', 'maribel.bellisima501@gmail.com', '13237077015', 'UM', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-13T22:48:38'),
  ('RETO15D-yanurca_90@hotmail.com', 'PURCHASE_COMPLETE', 'Yeison antonio Urina castellar', 'yanurca_90@hotmail.com', '573160404041', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-13T23:46:25'),
  ('RETO15D-paolarodriguezrealtor@gmail.com', 'PURCHASE_COMPLETE', 'Paola rodriguez', 'paolarodriguezrealtor@gmail.com', '17867155492', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T06:57:17'),
  ('RETO15D-ariess1986@gmail.com', 'PURCHASE_COMPLETE', 'Jose zamora', 'ariess1986@gmail.com', '573178913034', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T07:28:05'),
  ('RETO15D-aleja_9910_@hotmail.com', 'PURCHASE_COMPLETE', 'Maria Alejandra Garavito Garzon', 'aleja_9910_@hotmail.com', '573202274562', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T08:03:59'),
  ('RETO15D-yuland8825@hotmail.com', 'PURCHASE_COMPLETE', 'Andrea Agudelo', 'yuland8825@hotmail.com', '573148101878', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T08:25:10'),
  ('RETO15D-danielaramirez.9394@gmail.com', 'PURCHASE_COMPLETE', 'Daniela ramirez Ramirez', 'danielaramirez.9394@gmail.com', '573008651731', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T08:43:29'),
  ('RETO15D-patriciadoncel@gmail.com', 'PURCHASE_COMPLETE', 'Eliana Patricia Doncel Munoz', 'patriciadoncel@gmail.com', '13236102307', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T09:06:47'),
  ('RETO15D-ceo.harleycardozo@gmail.com', 'PURCHASE_COMPLETE', 'Jorge harley cardozo', 'ceo.harleycardozo@gmail.com', '573112458443', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T09:48:46'),
  ('RETO15D-deiviaguillon15@gmail.com', 'PURCHASE_COMPLETE', 'Deivi Aguillon', 'deiviaguillon15@gmail.com', '573132158297', 'CO', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T09:54:31'),
  ('RETO15D-lasgordas07@gmail.com', 'PURCHASE_COMPLETE', 'Sergio duenas', 'lasgordas07@gmail.com', '573214614480', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T12:50:06'),
  ('RETO15D-biancamga1981@gmail.com', 'PURCHASE_COMPLETE', 'Bianca garcia', 'biancamga1981@gmail.com', '17864368033', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T13:09:55'),
  ('RETO15D-emmanuellaraosorio@gmail.com', 'PURCHASE_COMPLETE', 'Jesus Emmanuel Lara Osorio', 'emmanuellaraosorio@gmail.com', '525617344912', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T14:45:14'),
  ('RETO15D-dayajuanes@gmail.com', 'PURCHASE_COMPLETE', 'Dayana Arias palacio', 'dayajuanes@gmail.com', '573194240124', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T14:59:59'),
  ('RETO15D-lozanitoml@gmail.com', 'PURCHASE_COMPLETE', 'Adriana Lozano', 'lozanitoml@gmail.com', '5930983180069', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T15:38:26'),
  ('RETO15D-cordobajehiver@gmail.com', 'PURCHASE_COMPLETE', 'Jehiver Córdoba', 'cordobajehiver@gmail.com', '573229201748', 'CO', 'Reto 15D', 20251021000000, 'USD', 'active', '2025-03-14T16:23:02'),
  ('RETO15D-francisco16.murilloz@gmail.com', 'PURCHASE_COMPLETE', 'Francisco murillo', 'francisco16.murilloz@gmail.com', '573004206261', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T17:03:08'),
  ('RETO15D-david_cardona16@hotmail.com', 'PURCHASE_COMPLETE', 'David Leonardo Hidalgo Cardona', 'david_cardona16@hotmail.com', '573046401161', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T18:30:30'),
  ('RETO15D-tomasina2718@yahoo.com', 'PURCHASE_COMPLETE', 'Tomasina Del rosario mejia', 'tomasina2718@yahoo.com', '116097277671', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T18:36:58'),
  ('RETO15D-cryptonano18@gmail.com', 'PURCHASE_COMPLETE', 'ONAN TANCO', 'cryptonano18@gmail.com', '51949666157', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T18:51:03'),
  ('RETO15D-luisamanriquebarrera1995@gmail.com', 'PURCHASE_COMPLETE', 'Luisa Fernanda Manrique Barrera', 'luisamanriquebarrera1995@gmail.com', '573216679242', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T19:53:49'),
  ('RETO15D-jorgedavidqw@gmail.com', 'PURCHASE_COMPLETE', 'Jorge David Diaz Rodriguez', 'jorgedavidqw@gmail.com', '573207365613', 'CO', 'Reto 15D', 20251021000000, 'USD', 'active', '2025-03-14T20:57:21'),
  ('RETO15D-juliajimenezarr@gmail.com', 'PURCHASE_COMPLETE', 'Julia Jimenez', 'juliajimenezarr@gmail.com', '17868163650', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-14T21:12:38'),
  ('RETO15D-kam.cuervo@gmail.com', 'PURCHASE_COMPLETE', 'Crysthian Triana', 'kam.cuervo@gmail.com', '573059259282', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-14T22:47:09'),
  ('RETO15D-yaime71@yahoo.com', 'PURCHASE_COMPLETE', 'Yaime de de la pena zamora', 'yaime71@yahoo.com', '17163499991', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-15T04:49:41'),
  ('RETO15D-tomasm235@gmail.com', 'PURCHASE_COMPLETE', 'Tomás R Martínez Castaño', 'tomasm235@gmail.com', '573186377546', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-15T05:07:41'),
  ('RETO15D-anamjaramillov@gmail.com', 'PURCHASE_COMPLETE', 'Ana M Jaramillo V', 'anamjaramillov@gmail.com', '573104353609', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T05:48:27'),
  ('RETO15D-tatisuarez593@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Suárez', 'tatisuarez593@gmail.com', '573146172815', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T06:22:46'),
  ('RETO15D-kevin.valenzuela000@gmail.com', 'PURCHASE_COMPLETE', 'Kevin valenzuela', 'kevin.valenzuela000@gmail.com', '573229187468', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T06:25:51'),
  ('RETO15D-gabrielriveravillamizar@gmail.com', 'PURCHASE_COMPLETE', 'Gabriel Rivera V', 'gabrielriveravillamizar@gmail.com', '573112777802', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T07:07:45'),
  ('RETO15D-carlos.bismarck36@gmail.com', 'PURCHASE_COMPLETE', 'Carlos bismarck', 'carlos.bismarck36@gmail.com', '523111055123', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-03-15T08:48:26'),
  ('RETO15D-cyn.pr16@hotmail.com', 'PURCHASE_COMPLETE', 'Cynthia pazaran romero', 'cyn.pr16@hotmail.com', '522227361946', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-03-15T10:32:57'),
  ('RETO15D-dianita1809@hotmail.com', 'PURCHASE_COMPLETE', 'Diana guarin', 'dianita1809@hotmail.com', '573045586003', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T10:40:56'),
  ('RETO15D-paolatca@yahoo.com', 'PURCHASE_COMPLETE', 'Paola Cardenas', 'paolatca@yahoo.com', '573006747445', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T12:01:05'),
  ('RETO15D-andresredmusic@gmail.com', 'PURCHASE_COMPLETE', 'carlos andres Rodríguez monsalve', 'andresredmusic@gmail.com', '573044313216', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T13:44:02'),
  ('RETO15D-yefersonandreshernandez1@gmail.com', 'PURCHASE_COMPLETE', 'Yeferson andres Hernandez david', 'yefersonandreshernandez1@gmail.com', '573002079041', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T14:43:27'),
  ('RETO15D-zulma_kmc92@hotmail.com', 'PURCHASE_COMPLETE', 'Zulma Morales', 'zulma_kmc92@hotmail.com', '523221078231', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-03-15T16:26:22'),
  ('RETO15D-hotmartcmc@gmail.com', 'PURCHASE_COMPLETE', 'Juan Camilo Mojica', 'hotmartcmc@gmail.com', '573144391836', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T18:17:47'),
  ('RETO15D-cagd2000@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Gomez', 'cagd2000@gmail.com', '573007845773', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T18:21:57'),
  ('RETO15D-alexandramazuerarealtor@gmail.com', 'PURCHASE_COMPLETE', 'Alexandra Mazuera', 'alexandramazuerarealtor@gmail.com', '117866206262', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-15T19:01:30'),
  ('RETO15D-vanidadybelleza@hotmail.com', 'PURCHASE_COMPLETE', 'Diana Carolina ledezma', 'vanidadybelleza@hotmail.com', '573147508381', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T19:21:12'),
  ('RETO15D-fernandorangel261121@gmail.com', 'PURCHASE_COMPLETE', 'Fernando Rangel', 'fernandorangel261121@gmail.com', '573013240412', 'CO', 'Reto 15D', 20251021000000, 'USD', 'active', '2025-03-15T19:52:58'),
  ('RETO15D-piguasbebes@gmail.com', 'PURCHASE_COMPLETE', 'Gloria Lucia Dominguez Reyes', 'piguasbebes@gmail.com', '573046156929', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-15T21:31:53'),
  ('RETO15D-abigailgarcia1512@gmail.com', 'PURCHASE_COMPLETE', 'Abigail Garcia', 'abigailgarcia1512@gmail.com', '15104679208', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-15T21:52:16'),
  ('RETO15D-ventasarcangel1@gmail.com', 'PURCHASE_COMPLETE', 'Paula Andrea Vanegas Salazar', 'ventasarcangel1@gmail.com', '573202954889', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-15T22:18:57'),
  ('RETO15D-judacorps@gmail.com', 'PURCHASE_COMPLETE', 'Manuel Lopez', 'judacorps@gmail.com', '118173740527', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-16T04:12:17'),
  ('RETO15D-loreje28@gmail.com', 'PURCHASE_COMPLETE', 'Jessica lorena ramirez romero', 'loreje28@gmail.com', '573113073948', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T07:48:58'),
  ('RETO15D-mariatmc.19@gmail.com', 'PURCHASE_COMPLETE', 'Maria Teresa Maldonado', 'mariatmc.19@gmail.com', '573106255998', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T08:46:43'),
  ('RETO15D-angelatorresm@gmail.com', 'PURCHASE_COMPLETE', 'Angela Torres', 'angelatorresm@gmail.com', '573204493528', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-16T08:57:13'),
  ('RETO15D-juancarlos0006@gmail.com', 'PURCHASE_COMPLETE', 'Juan Carlos Guerrero', 'juancarlos0006@gmail.com', '573214877190', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T09:35:17'),
  ('RETO15D-kathemrealestate7@gmail.com', 'PURCHASE_COMPLETE', 'Katherine Macea Cardona', 'kathemrealestate7@gmail.com', '573028646596', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T10:02:26'),
  ('RETO15D-amoblandotusideas@gmail.com', 'PURCHASE_COMPLETE', 'Ivan david aparicio rojas', 'amoblandotusideas@gmail.com', '573006881618', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T12:18:32'),
  ('RETO15D-julher1124@hotmail.com', 'PURCHASE_COMPLETE', 'Julián Andrés Ocoro Hernández', 'julher1124@hotmail.com', '573158525386', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T13:38:27'),
  ('RETO15D-pabloog979899@gmail.com', 'PURCHASE_COMPLETE', 'Pablo ospina gutierrez', 'pabloog979899@gmail.com', '573217843390', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T15:54:44'),
  ('RETO15D-marianaandrebanol@gmail.com', 'PURCHASE_COMPLETE', 'Maríana Banol', 'marianaandrebanol@gmail.com', '573217527016', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T17:45:06'),
  ('RETO15D-iliana.inca@gmail.com', 'PURCHASE_COMPLETE', 'Iliana Isabel Inca Sanchez', 'iliana.inca@gmail.com', '593984663178', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-16T20:47:40'),
  ('RETO15D-st.correa93@gmail.com', 'PURCHASE_COMPLETE', 'stephany correa jimenez', 'st.correa93@gmail.com', '573232009900', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-16T21:31:54'),
  ('RETO15D-mayerlyn.suarez@gmail.com', 'PURCHASE_COMPLETE', 'Maye Suárez', 'mayerlyn.suarez@gmail.com', '524427166733', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-03-17T09:58:01'),
  ('RETO15D-dazaw7@gmail.com', 'PURCHASE_COMPLETE', 'Wilson Daza Duque', 'dazaw7@gmail.com', '573505350508', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-17T12:51:29'),
  ('RETO15D-astridcarooficial.negocios@gmail.com', 'PURCHASE_COMPLETE', 'Astrid Carolina Chaves Preciado', 'astridcarooficial.negocios@gmail.com', '573205154058', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-17T15:32:21'),
  ('RETO15D-fgrleilani@aol.com', 'PURCHASE_COMPLETE', 'Leilani Figueroa', 'fgrleilani@aol.com', '14079826009', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-17T16:59:00'),
  ('RETO15D-moniburgueno8@gmail.com', 'PURCHASE_COMPLETE', 'Monica burgueno', 'moniburgueno8@gmail.com', '14808881805', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-17T20:02:11'),
  ('RETO15D-harold.caro29@gmail.com', 'PURCHASE_COMPLETE', 'Harold Caro caro', 'harold.caro29@gmail.com', '573226799296', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-17T21:42:00'),
  ('RETO15D-leslieromero2020@gmail.com', 'PURCHASE_COMPLETE', 'Leslie garcia', 'leslieromero2020@gmail.com', '17327446869', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-18T06:05:28'),
  ('RETO15D-larisa.stifiuc@gmail.com', 'PURCHASE_COMPLETE', 'Larisa Mihaela Stifiuc', 'larisa.stifiuc@gmail.com', '34623447245', 'ES', 'Reto 15D', 37.14, 'USD', 'active', '2025-03-18T06:41:11'),
  ('RETO15D-vivi.gallego.com@gmail.com', 'PURCHASE_COMPLETE', 'Viviana gallego', 'vivi.gallego.com@gmail.com', '573005124370', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T06:58:48'),
  ('RETO15D-marimil.pj@gmail.com', 'PURCHASE_COMPLETE', 'Maria Milagros Urdaneta Lopez', 'marimil.pj@gmail.com', '573054121095', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T07:53:53'),
  ('RETO15D-alexacorreajaramillo@gmail.com', 'PURCHASE_COMPLETE', 'Alexa Correa Jaramillo', 'alexacorreajaramillo@gmail.com', '573163520040', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T09:09:02'),
  ('RETO15D-johannamoreano@hotmail.com', 'PURCHASE_COMPLETE', 'Johanna Moreano Garcés', 'johannamoreano@hotmail.com', '573127813990', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T09:49:58'),
  ('RETO15D-acidopotente3@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Rodriguez', 'acidopotente3@gmail.com', '16153724537', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-18T10:29:02'),
  ('RETO15D-kubantmllc@gmail.com', 'PURCHASE_COMPLETE', 'Yadira Batista', 'kubantmllc@gmail.com', '13234940762', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-18T10:32:32'),
  ('RETO15D-juantorres101705@gmail.com', 'PURCHASE_COMPLETE', 'Juan Felipe torres bolaños', 'juantorres101705@gmail.com', '573242673698', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T10:38:27'),
  ('RETO15D-juliquicenoo@gmail.com', 'PURCHASE_COMPLETE', 'Juliana Quiceno Ospina', 'juliquicenoo@gmail.com', '573002142811', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T12:30:46'),
  ('RETO15D-kevin.trafficker.digital@gmail.com', 'PURCHASE_COMPLETE', 'Kevin Guerrero', 'kevin.trafficker.digital@gmail.com', '573225912298', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T12:37:58'),
  ('RETO15D-tecnofrutales@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Marcela Cano Betancur', 'tecnofrutales@gmail.com', '573128607186', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T16:21:25'),
  ('RETO15D-andii.tostado@gmail.com', 'PURCHASE_COMPLETE', 'Andrea Tostado', 'andii.tostado@gmail.com', '525567083336', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-03-18T19:03:24'),
  ('RETO15D-camilonetworking982@gmail.com', 'PURCHASE_COMPLETE', 'camilo andres rodriguez vasquez', 'camilonetworking982@gmail.com', '573154240846', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-18T20:53:33'),
  ('RETO15D-cablejireh@gmail.com', 'PURCHASE_COMPLETE', 'Fabiola Mosquera', 'cablejireh@gmail.com', '117723425825', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-19T03:58:53'),
  ('RETO15D-euroxbarber@gmail.com', 'PURCHASE_COMPLETE', 'Josue Figueroa', 'euroxbarber@gmail.com', '573232331935', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-19T04:20:09'),
  ('RETO15D-isabellasanchezgomez99@gmail.com', 'PURCHASE_COMPLETE', 'Isabella Sánchez', 'isabellasanchezgomez99@gmail.com', '573144736516', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-19T07:39:58'),
  ('RETO15D-nikoaleja2609@gmail.com', 'PURCHASE_COMPLETE', 'Maira Alejandra Batista Herazo', 'nikoaleja2609@gmail.com', '573045258259', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-19T08:35:09'),
  ('RETO15D-dbbermudezs@gmail.com', 'PURCHASE_COMPLETE', 'Dennis Bermudez', 'dbbermudezs@gmail.com', '573043360451', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-19T10:10:13'),
  ('RETO15D-luza606@msn.com', 'PURCHASE_COMPLETE', 'Luza Perez hoyos', 'luza606@msn.com', '573017697175', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-19T12:34:31'),
  ('RETO15D-egaleano2827@gmail.com', 'PURCHASE_COMPLETE', 'Eliana Galeano', 'egaleano2827@gmail.com', '573126401886', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-19T12:54:57'),
  ('RETO15D-wladdys1313@gmail.com', 'PURCHASE_COMPLETE', 'Wladimir Cadena Benitez', 'wladdys1313@gmail.com', '5930984054785', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-19T21:59:35'),
  ('RETO15D-ginanataliasoto@outlook.com', 'PURCHASE_COMPLETE', 'Gina Natalia Soto', 'ginanataliasoto@outlook.com', '573104234197', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-19T22:12:01'),
  ('RETO15D-danielabecerril.diseno@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Becerril', 'danielabecerril.diseno@gmail.com', '525514876471', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-20T02:28:20'),
  ('RETO15D-linacorrea93@hotmail.com', 'PURCHASE_COMPLETE', 'Lina Correa', 'linacorrea93@hotmail.com', '118636772088', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-20T07:36:01'),
  ('RETO15D-andreasabando@icloud.com', 'PURCHASE_COMPLETE', 'Andrea sabando', 'andreasabando@icloud.com', '5930999768295', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-20T07:44:29'),
  ('RETO15D-elilorojas@yahoo.com', 'PURCHASE_COMPLETE', 'Eliana lotero rojas', 'elilorojas@yahoo.com', '573206036160', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-20T09:24:40'),
  ('RETO15D-jeffersonperico1993@gmail.com', 'PURCHASE_COMPLETE', 'Jefferson Perico', 'jeffersonperico1993@gmail.com', '573052958797', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-20T09:50:06'),
  ('RETO15D-dbalcazar@uees.edu.ec', 'PURCHASE_COMPLETE', 'Doménica Balcázar', 'dbalcazar@uees.edu.ec', '5930999758892', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-20T11:37:54'),
  ('RETO15D-evelyniza1995@gmail.com', 'PURCHASE_COMPLETE', 'Evelyn Hincapié Villanueva', 'evelyniza1995@gmail.com', '573175633124', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-20T15:57:22'),
  ('RETO15D-alexgcanog1@gmail.com', 'PURCHASE_COMPLETE', 'Alex Guillermo Cano Gomez', 'alexgcanog1@gmail.com', '573242366011', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-20T17:07:24'),
  ('RETO15D-dacore99999@gmail.com', 'PURCHASE_COMPLETE', 'David Parra', 'dacore99999@gmail.com', '573207167950', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-20T20:21:16'),
  ('RETO15D-mayerli1205@gmail.com', 'PURCHASE_COMPLETE', 'mallerline naranjo', 'mayerli1205@gmail.com', '573113433934', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-20T22:44:00'),
  ('RETO15D-diamogo21@hotmail.com', 'PURCHASE_COMPLETE', 'Diyeneis Andrea Moreno Gomez', 'diamogo21@hotmail.com', '573148278102', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-20T23:38:02'),
  ('RETO15D-anama_eraso@hotmail.com', 'PURCHASE_COMPLETE', 'Ana Maria Eraso', 'anama_eraso@hotmail.com', '573178595220', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-21T07:57:42'),
  ('RETO15D-alejasegundacuenta2@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Ortiz', 'alejasegundacuenta2@gmail.com', '573124041225', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-21T08:09:09'),
  ('RETO15D-moreno_t_a@hotmail.com', 'PURCHASE_COMPLETE', 'Alfredo Moreno', 'moreno_t_a@hotmail.com', '523312510180', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-21T09:48:10'),
  ('RETO15D-lululoaiza@gmail.com', 'PURCHASE_COMPLETE', 'Luisa loaiza', 'lululoaiza@gmail.com', '573003074733', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-21T13:26:23'),
  ('RETO15D-juli.mendoza.jam@gmail.com', 'PURCHASE_COMPLETE', 'Julia Mendoza', 'juli.mendoza.jam@gmail.com', '18019280053', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-21T14:09:52'),
  ('RETO15D-ccamilo.molina@gmail.com', 'PURCHASE_COMPLETE', 'Cristian Camilo Molina Restrepo', 'ccamilo.molina@gmail.com', '573237777461', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-21T14:47:49'),
  ('RETO15D-alejandragrues@gmail.com', 'PURCHASE_COMPLETE', 'Yunis Alejandra grueso Baron', 'alejandragrues@gmail.com', '573123495375', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-21T16:46:49'),
  ('RETO15D-lucecitamejiabaron@gmail.com', 'PURCHASE_COMPLETE', 'Luz Maritza Mejia-Baron', 'lucecitamejiabaron@gmail.com', '12039069751', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-21T17:45:53'),
  ('RETO15D-doradasbypaolaortiz@gmail.com', 'PURCHASE_COMPLETE', 'Marco Tabone', 'doradasbypaolaortiz@gmail.com', '573150604468', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-21T21:43:45'),
  ('RETO15D-clio333@hotmail.com', 'PURCHASE_COMPLETE', 'Leonardo Salgado Carmona', 'clio333@hotmail.com', '573108231536', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T04:21:25'),
  ('RETO15D-angiepala@hotmail.com', 'PURCHASE_COMPLETE', 'Angelica Palacio', 'angiepala@hotmail.com', '573206719293', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T07:08:56'),
  ('RETO15D-luoneelop@hotmail.com', 'PURCHASE_COMPLETE', 'Ivonee lopez', 'luoneelop@hotmail.com', '19092681354', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-22T07:59:58'),
  ('RETO15D-danieldonado690@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Donado', 'danieldonado690@gmail.com', '573127779472', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T08:29:09'),
  ('RETO15D-cristianarango0610@gmail.com', 'PURCHASE_COMPLETE', 'Cristian alejandro arango', 'cristianarango0610@gmail.com', '573028426307', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T09:11:13'),
  ('RETO15D-pilarbernal08@gmail.com', 'PURCHASE_COMPLETE', 'Pilar Rocío Bernal Gonzalez', 'pilarbernal08@gmail.com', '573102844675', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T09:23:55'),
  ('RETO15D-kellyh1093@gmail.com', 'PURCHASE_COMPLETE', 'Kelly Hoyos', 'kellyh1093@gmail.com', '573135356590', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T10:52:45'),
  ('RETO15D-celeste@aicca.com.mx', 'PURCHASE_COMPLETE', 'Celeste Beltran', 'celeste@aicca.com.mx', '525563172786', 'MX', 'Reto 15D', 37.02, 'USD', 'active', '2025-03-22T11:26:25'),
  ('RETO15D-marketingbydvg@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Varona', 'marketingbydvg@gmail.com', '19294207680', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-22T11:27:21'),
  ('RETO15D-sebastianmontes6@gmail.com', 'PURCHASE_COMPLETE', 'sebastian montes', 'sebastianmontes6@gmail.com', '573114218571', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T11:54:56'),
  ('RETO15D-pymeza@gmail.com', 'PURCHASE_COMPLETE', 'Patricia Yaneth Meza Leal', 'pymeza@gmail.com', '527227116586', 'MX', 'Reto 15D', 37.02, 'USD', 'active', '2025-03-22T15:25:37'),
  ('RETO15D-bryan.jaimes24@gmail.com', 'PURCHASE_COMPLETE', 'Bryan Jaimes', 'bryan.jaimes24@gmail.com', '573137445857', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T17:57:25'),
  ('RETO15D-mia8693@gmail.com', 'PURCHASE_COMPLETE', 'Mia salazar', 'mia8693@gmail.com', '523339561340', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-03-22T20:23:34'),
  ('RETO15D-tatianadiezmalagon@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Diez', 'tatianadiezmalagon@gmail.com', '525549651420', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-03-22T20:57:52'),
  ('RETO15D-jwalda91@gmail.com', 'PURCHASE_COMPLETE', 'Josselyn Waleska Ramos Marroquin', 'jwalda91@gmail.com', '50246008228', 'GT', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-22T22:35:50'),
  ('RETO15D-sebasmc599@gmail.com', 'PURCHASE_COMPLETE', 'Sebastian Medina', 'sebasmc599@gmail.com', '573007624046', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-22T23:36:00'),
  ('RETO15D-joseval30@yahoo.com', 'PURCHASE_COMPLETE', 'Jose Guerrero', 'joseval30@yahoo.com', '5930991990977', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-23T04:20:04'),
  ('RETO15D-danangarital@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Esteban Angarita Leal', 'danangarital@gmail.com', '573186610755', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-23T07:38:19'),
  ('RETO15D-cere0720@gmail.com', 'PURCHASE_COMPLETE', 'Cecilia Regalado', 'cere0720@gmail.com', '113477771714', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-23T09:39:10'),
  ('RETO15D-ceregalado68@gmail.com', 'PURCHASE_COMPLETE', 'Cecilia Regalado', 'ceregalado68@gmail.com', '113477771714', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-23T09:45:35'),
  ('RETO15D-infoclaravelasquez@gmail.com', 'PURCHASE_COMPLETE', 'Clara Velasquez', 'infoclaravelasquez@gmail.com', '573115529352', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-24T08:05:11'),
  ('RETO15D-anyelina84@hotmail.com', 'PURCHASE_COMPLETE', 'Angela Patricia Mendez Tello', 'anyelina84@hotmail.com', '573156735824', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-24T09:50:17'),
  ('RETO15D-cedaacmx@gmail.com', 'PURCHASE_COMPLETE', 'Ana karen beltran lastra', 'cedaacmx@gmail.com', '527828889820', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-03-24T10:41:18'),
  ('RETO15D-jdlopezdu@gmail.com', 'PURCHASE_COMPLETE', 'Juan David Lopez', 'jdlopezdu@gmail.com', '17043963485', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-24T14:44:13'),
  ('RETO15D-paca993@hotmail.com', 'PURCHASE_COMPLETE', 'Paula Arias', 'paca993@hotmail.com', '573116461874', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-24T18:23:54'),
  ('RETO15D-lemosky94@gmail.com', 'PURCHASE_COMPLETE', 'David esteban lemos caicedo', 'lemosky94@gmail.com', '573185287540', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-24T18:56:39'),
  ('RETO15D-luismaquesadaborrero@gmail.com', 'PURCHASE_COMPLETE', 'Luis Manuel Quesada Borrero', 'luismaquesadaborrero@gmail.com', '12104007234', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-24T20:06:57'),
  ('RETO15D-destebanmartinez@icloud.com', 'PURCHASE_COMPLETE', 'Daniel Esteban Martínez', 'destebanmartinez@icloud.com', '573209152101', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T07:00:12'),
  ('RETO15D-luzstelladuce@gmail.com', 'PURCHASE_COMPLETE', 'Luz Duarte', 'luzstelladuce@gmail.com', '573133869389', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T07:08:18'),
  ('RETO15D-pasifico@gmail.com', 'PURCHASE_COMPLETE', 'Javier Angulo', 'pasifico@gmail.com', '19807779354', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-25T07:42:54'),
  ('RETO15D-alerojasarizaga@gmail.com', 'PURCHASE_COMPLETE', 'Ale Rojas', 'alerojasarizaga@gmail.com', '524613462168', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-03-25T09:59:17'),
  ('RETO15D-berdaju2012@gmail.com', 'PURCHASE_COMPLETE', 'Julian Berdugo', 'berdaju2012@gmail.com', '573134109853', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T11:45:06'),
  ('RETO15D-cordobakettyyohana@gmail.com', 'PURCHASE_COMPLETE', 'Ketty Yohana Córdoba', 'cordobakettyyohana@gmail.com', '573226747868', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T16:50:07'),
  ('RETO15D-juliethleslie049@gmail.com', 'PURCHASE_COMPLETE', 'Ruth Elena Caceres', 'juliethleslie049@gmail.com', '573128462945', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T18:24:32'),
  ('RETO15D-fercastro.rico@gmail.com', 'PURCHASE_COMPLETE', 'Yennyfer Styffen Castro Rico', 'fercastro.rico@gmail.com', '573212255839', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-25T19:18:39'),
  ('RETO15D-dalazu0717@gmail.com', 'PURCHASE_COMPLETE', 'Daniela lasso zuluaga', 'dalazu0717@gmail.com', '573156157717', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T21:37:23'),
  ('RETO15D-subgerenciaconexiontrip@gmail.com', 'PURCHASE_COMPLETE', 'Juan pablo Castañeda', 'subgerenciaconexiontrip@gmail.com', '573117363187', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-25T22:02:28'),
  ('RETO15D-claudianailstx@gmail.com', 'PURCHASE_COMPLETE', 'Claudia herrera', 'claudianailstx@gmail.com', '17542731793', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-26T06:35:32'),
  ('RETO15D-ftalejandragomez@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Gómez', 'ftalejandragomez@gmail.com', '573104160754', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T06:58:26'),
  ('RETO15D-daniigomez08@gmail.com', 'PURCHASE_COMPLETE', 'Daniela gomez', 'daniigomez08@gmail.com', '573104257837', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T07:04:40'),
  ('RETO15D-vallejo_7906@hotmail.com', 'PURCHASE_COMPLETE', 'Oscar Rodriguez', 'vallejo_7906@hotmail.com', '573213764052', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T08:42:51'),
  ('RETO15D-laurahurtado_2018@hotmail.com', 'PURCHASE_COMPLETE', 'Laura marcela hurtado tabares', 'laurahurtado_2018@hotmail.com', '573107948191', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T11:56:30'),
  ('RETO15D-gamana2809@gmail.com', 'PURCHASE_COMPLETE', 'Gabriella Lagonell', 'gamana2809@gmail.com', '17274323890', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-26T12:16:36'),
  ('RETO15D-ypr-11@hotmail.com', 'PURCHASE_COMPLETE', 'Yeison ricardo pineda Gutiérrez', 'ypr-11@hotmail.com', '573214687298', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T13:10:26'),
  ('RETO15D-mariatutyaccesorios@gmail.com', 'PURCHASE_COMPLETE', 'Maria isabel andrade', 'mariatutyaccesorios@gmail.com', '573105673136', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-26T13:27:52'),
  ('RETO15D-cropmark@me.com', 'PURCHASE_COMPLETE', 'Jorge A. Murillo', 'cropmark@me.com', '525550733773', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-03-26T13:38:36'),
  ('RETO15D-caritorincon@gmail.com', 'PURCHASE_COMPLETE', 'Carolina Rincon', 'caritorincon@gmail.com', '573103432788', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T15:40:39'),
  ('RETO15D-juanramonpro@gmail.com', 'PURCHASE_COMPLETE', 'Juan Ramon Pacahuala', 'juanramonpro@gmail.com', '51970725439', 'PE', 'Reto 15D', 31.62, 'USD', 'active', '2025-03-26T19:48:50'),
  ('RETO15D-gabymu1855@gmail.com', 'PURCHASE_COMPLETE', 'Gabriela Muñoz', 'gabymu1855@gmail.com', '573138995315', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T21:16:03'),
  ('RETO15D-cqg237@gmail.com', 'PURCHASE_COMPLETE', 'Maria Camila Quintero Giraldo', 'cqg237@gmail.com', '573176013135', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T21:25:32'),
  ('RETO15D-susipulga23@gmail.com', 'PURCHASE_COMPLETE', 'Susana Pulgarin', 'susipulga23@gmail.com', '573052504884', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-26T22:33:19'),
  ('RETO15D-andrecastello@gmail.com', 'PURCHASE_COMPLETE', 'André Castelló', 'andrecastello@gmail.com', '593984693430', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-26T23:45:48'),
  ('RETO15D-noashopfl@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Esquivel', 'noashopfl@gmail.com', '19046318023', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T03:20:34'),
  ('RETO15D-santanderbarraza@gmail.com', 'PURCHASE_COMPLETE', 'Santander Barraza', 'santanderbarraza@gmail.com', '573005537278', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T06:02:01'),
  ('RETO15D-kromaticadesign@gmail.com', 'PURCHASE_COMPLETE', 'Laura Duque', 'kromaticadesign@gmail.com', '573152470355', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T07:39:57'),
  ('RETO15D-barbosaperezalejandra@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Barbosa', 'barbosaperezalejandra@gmail.com', '573174027633', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T07:43:13'),
  ('RETO15D-valenti1903@hotmail.com', 'PURCHASE_COMPLETE', 'Julieth campo Dorado', 'valenti1903@hotmail.com', '573113396026', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T07:50:50'),
  ('RETO15D-ana.roldantv@gmail.com', 'PURCHASE_COMPLETE', 'Ana maria Roldan ospina', 'ana.roldantv@gmail.com', '573006100797', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-27T08:00:16'),
  ('RETO15D-caicedo.orrego17@gmail.com', 'PURCHASE_COMPLETE', 'Angélica Caicedo', 'caicedo.orrego17@gmail.com', '573167092195', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T11:26:27'),
  ('RETO15D-malejagalo3@gmail.com', 'PURCHASE_COMPLETE', 'Maira lejandra Galindo Lopez', 'malejagalo3@gmail.com', '573104753563', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T11:41:34'),
  ('RETO15D-visionbloomstudio@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Di María', 'visionbloomstudio@gmail.com', '112517532998', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T11:54:00'),
  ('RETO15D-germandelgadotoledo@gmail.com', 'PURCHASE_COMPLETE', 'German Delgado Toledo', 'germandelgadotoledo@gmail.com', '573104199547', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T11:59:13'),
  ('RETO15D-castanedanicolas08@gmail.com', 'PURCHASE_COMPLETE', 'Brayan Nicolas Castañeda Vargas', 'castanedanicolas08@gmail.com', '573052991289', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T12:28:53'),
  ('RETO15D-bubalulajey@gmail.com', 'PURCHASE_COMPLETE', 'Jennifer Amaya Ulloa', 'bubalulajey@gmail.com', '573164722696', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T12:40:39'),
  ('RETO15D-1993marcela.rios@gmail.com', 'PURCHASE_COMPLETE', 'Jenny marcela ríos Larrea', '1993marcela.rios@gmail.com', '573014888981', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T13:28:37'),
  ('RETO15D-luisalinasrealestatemarketing@gmail.com', 'PURCHASE_COMPLETE', 'Luis Salinas', 'luisalinasrealestatemarketing@gmail.com', '113233654847', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T15:21:35'),
  ('RETO15D-vegonio276@gmail.com', 'PURCHASE_COMPLETE', 'John Enrique Navarro Ortiz', 'vegonio276@gmail.com', '573163682817', 'CO', 'Reto 15D', 36.60, 'USD', 'active', '2025-03-27T15:36:20'),
  ('RETO15D-soarisnovarealtor@gmail.com', 'PURCHASE_COMPLETE', 'Soaris Nova', 'soarisnovarealtor@gmail.com', '18138935382', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T17:01:37'),
  ('RETO15D-aprendecompartiendo2022@gmail.com', 'PURCHASE_COMPLETE', 'Carlos bedoya', 'aprendecompartiendo2022@gmail.com', '13013265555', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T17:05:23'),
  ('RETO15D-v_valdes@outlook.com', 'PURCHASE_COMPLETE', 'Veronica Valdes', 'v_valdes@outlook.com', '573162213685', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T17:38:56'),
  ('RETO15D-adri.camargo84@gmail.com', 'PURCHASE_COMPLETE', 'Adriana Camargo', 'adri.camargo84@gmail.com', '14075762800', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T18:15:27'),
  ('RETO15D-diegopoveda09@gmail.com', 'PURCHASE_COMPLETE', 'Diego Poveda', 'diegopoveda09@gmail.com', '5930992731464', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-27T19:27:23'),
  ('RETO15D-maleja.pv0209@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Patiño', 'maleja.pv0209@gmail.com', '573153868151', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T20:02:30'),
  ('RETO15D-jussie121@gmail.com', 'PURCHASE_COMPLETE', 'Gretty Granobles', 'jussie121@gmail.com', '573116125119', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T20:03:27'),
  ('RETO15D-cristhian.p1994@gmail.com', 'PURCHASE_COMPLETE', 'Cristhian Perez', 'cristhian.p1994@gmail.com', '573014596298', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-27T22:06:44'),
  ('RETO15D-sorocaimask8@gmail.com', 'PURCHASE_COMPLETE', 'Levys Villafranca', 'sorocaimask8@gmail.com', '573015304354', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T00:23:37'),
  ('RETO15D-tobonjudy@gmail.com', 'PURCHASE_COMPLETE', 'Judy Tobón', 'tobonjudy@gmail.com', '573504963460', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T00:30:42'),
  ('RETO15D-karlasanabria@yahoo.es', 'PURCHASE_COMPLETE', 'Karla sanbria', 'karlasanabria@yahoo.es', '573015837700', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T01:23:02'),
  ('RETO15D-lizethduran0321@hotmail.com', 'PURCHASE_COMPLETE', 'Teresa Duran galeano', 'lizethduran0321@hotmail.com', '573105008063', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T06:21:11'),
  ('RETO15D-arq.jcjimenez0@gmail.com', 'PURCHASE_COMPLETE', 'Juan camilo Jiménez', 'arq.jcjimenez0@gmail.com', '573213162803', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-28T07:27:42'),
  ('RETO15D-paugonzalezg2017@hotmail.com', 'PURCHASE_COMPLETE', 'Paula Gonzalez Guzmán', 'paugonzalezg2017@hotmail.com', '573188042969', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T11:32:03'),
  ('RETO15D-paulaandreajimenezruiz@gmail.com', 'PURCHASE_COMPLETE', 'Paula Andrea Jiménez Ruiz', 'paulaandreajimenezruiz@gmail.com', '573013850912', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T15:13:45'),
  ('RETO15D-rcsepulveda4@gmail.com', 'PURCHASE_COMPLETE', 'REBECCA SEPÚLVEDA', 'rcsepulveda4@gmail.com', '50254826023', 'GT', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T15:29:51'),
  ('RETO15D-betancourt.oje@gmail.com', 'PURCHASE_COMPLETE', 'John enrique betancourt ospina', 'betancourt.oje@gmail.com', '573222436044', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T15:30:02'),
  ('RETO15D-betancourthbo@gmail.com', 'PURCHASE_COMPLETE', 'Hernán Betancourt Ospina', 'betancourthbo@gmail.com', '573022629299', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T15:44:43'),
  ('RETO15D-justine14_7@hotmail.com', 'PURCHASE_COMPLETE', 'Justine Acosta', 'justine14_7@hotmail.com', '5930995748669', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-28T16:12:39'),
  ('RETO15D-lideres365global@gmail.com', 'PURCHASE_COMPLETE', 'Hector Galensky Romero Baron', 'lideres365global@gmail.com', '593990369791', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-28T16:31:35'),
  ('RETO15D-angelikco09@gmail.com', 'PURCHASE_COMPLETE', 'angelica Carvajal', 'angelikco09@gmail.com', '573113839830', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T17:29:05'),
  ('RETO15D-mateo3329edinsonkate@gmail.com', 'PURCHASE_COMPLETE', 'Edinson córdoba mosquera', 'mateo3329edinsonkate@gmail.com', '573046351210', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T17:58:47'),
  ('RETO15D-juanselomo@gmail.com', 'PURCHASE_COMPLETE', 'Juan Sebastián López Molina', 'juanselomo@gmail.com', '573015486700', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T20:56:18'),
  ('RETO15D-norisrangel2017@gmail.com', 'PURCHASE_COMPLETE', 'Noris Villarruel', 'norisrangel2017@gmail.com', '573145364462', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T21:20:08'),
  ('RETO15D-heidy.digital@gmail.com', 'PURCHASE_COMPLETE', 'Heidy Herrera', 'heidy.digital@gmail.com', '573187441178', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-28T22:42:55'),
  ('RETO15D-santiaristi_1994@hotmail.com', 'PURCHASE_COMPLETE', 'Santiago guarin Aristizábal', 'santiaristi_1994@hotmail.com', '573183050370', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-28T23:10:31'),
  ('RETO15D-andre1726_@hotmail.com', 'PURCHASE_COMPLETE', 'Andrea Gil lopez', 'andre1726_@hotmail.com', '573133872078', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T06:10:39'),
  ('RETO15D-milen256@gmail.com', 'PURCHASE_COMPLETE', 'Milena Osorio', 'milen256@gmail.com', '573122329420', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-29T06:55:23'),
  ('RETO15D-adrianarp06@hotmail.com', 'PURCHASE_COMPLETE', 'Adriana Rojas prado', 'adrianarp06@hotmail.com', '573162238883', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T07:00:19'),
  ('RETO15D-klminorta@gmail.com', 'PURCHASE_COMPLETE', 'Karen Lorena minorta', 'klminorta@gmail.com', '573232336565', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T07:50:12'),
  ('RETO15D-cruzjohana027@gmail.com', 'PURCHASE_COMPLETE', 'Johana Cruz Dorado', 'cruzjohana027@gmail.com', '573145089420', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T09:00:01'),
  ('RETO15D-ramirezlam80@gmail.com', 'PURCHASE_COMPLETE', 'Luis Ramirez', 'ramirezlam80@gmail.com', '522282298629', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-29T12:14:36'),
  ('RETO15D-rdavid.mendoza.j@gmail.com', 'PURCHASE_COMPLETE', 'David Mendoza', 'rdavid.mendoza.j@gmail.com', '524434652008', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-29T12:17:07'),
  ('RETO15D-adri.bulla16@hotmail.com', 'PURCHASE_COMPLETE', 'Adrián Felipe Bulla Bernal', 'adri.bulla16@hotmail.com', '573102906736', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T12:49:34'),
  ('RETO15D-apps@pablodice.mx', 'PURCHASE_COMPLETE', 'Pablo Rodriguez', 'apps@pablodice.mx', '526671855039', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-03-29T13:22:22'),
  ('RETO15D-milenagomezarcila@gmail.com', 'PURCHASE_COMPLETE', 'Olga Milena Gomez Arcila', 'milenagomezarcila@gmail.com', '573016167171', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T13:33:38'),
  ('RETO15D-patriciacamelo10@gmail.com', 'PURCHASE_COMPLETE', 'Patricia camelo', 'patriciacamelo10@gmail.com', '18134246314', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-29T14:57:53'),
  ('RETO15D-ericklef@hotmail.com', 'PURCHASE_COMPLETE', 'ERICK DANIEL RAMIREZ MENDEZ', 'ericklef@hotmail.com', '13056273474', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-29T16:21:16'),
  ('RETO15D-juandlondono27@gmail.com', 'PURCHASE_COMPLETE', 'Juan David Londoño Valle', 'juandlondono27@gmail.com', '573148631231', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T18:20:15'),
  ('RETO15D-mile.h.g@hotmail.com', 'PURCHASE_COMPLETE', 'Sandra milena Hernandez galeano', 'mile.h.g@hotmail.com', '573156162249', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-29T18:35:10'),
  ('RETO15D-angelicarod24@gmail.com', 'PURCHASE_COMPLETE', 'Angelica Rodriguez', 'angelicarod24@gmail.com', '13475244770', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-30T06:44:40'),
  ('RETO15D-meli.palacio73@gmail.com', 'PURCHASE_COMPLETE', 'Melisa palacio parra', 'meli.palacio73@gmail.com', '119294317767', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-30T08:06:17'),
  ('RETO15D-oszysalazar@gmail.com', 'PURCHASE_COMPLETE', 'Osana M Salazar', 'oszysalazar@gmail.com', '17864198139', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-30T08:12:18'),
  ('RETO15D-nataliapastran494@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Saenz', 'nataliapastran494@gmail.com', '19549977397', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-30T10:19:20'),
  ('RETO15D-stefy_0523@hotmail.com', 'PURCHASE_COMPLETE', 'stephane malkun', 'stefy_0523@hotmail.com', '573214458684', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-30T11:02:09'),
  ('RETO15D-zerolatitude.ms@gmail.com', 'PURCHASE_COMPLETE', 'Luis Mosquera', 'zerolatitude.ms@gmail.com', '16469961579', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-03-30T12:11:21'),
  ('RETO15D-admicompramas@gmail.com', 'PURCHASE_COMPLETE', 'Kevin Leandro Sánchez moncaleano', 'admicompramas@gmail.com', '573185312170', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T12:13:39'),
  ('RETO15D-jcorredor82@gmail.com', 'PURCHASE_COMPLETE', 'Javier Corredor', 'jcorredor82@gmail.com', '573202324707', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T12:25:47'),
  ('RETO15D-ielvanvan97@gmail.com', 'PURCHASE_COMPLETE', 'Iván Darío cavadia babilonia', 'ielvanvan97@gmail.com', '573233140545', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T13:13:18'),
  ('RETO15D-catanoclavijod@gmail.com', 'PURCHASE_COMPLETE', 'Diana Marcela Cataño Clavijo', 'catanoclavijod@gmail.com', '573059468602', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T15:25:20'),
  ('RETO15D-ansato23@gmail.com', 'PURCHASE_COMPLETE', 'Angelo Samboni', 'ansato23@gmail.com', '573117179466', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T17:22:28'),
  ('RETO15D-jma9974@gmail.com', 'PURCHASE_COMPLETE', 'Jhonattan Manrique', 'jma9974@gmail.com', '573113746732', 'CO', 'Reto 15D', 1.85, 'USD', 'active', '2025-03-30T19:32:08'),
  ('RETO15D-andresdavid.garciam@gmail.com', 'PURCHASE_COMPLETE', 'Andrés García', 'andresdavid.garciam@gmail.com', '573196050295', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T22:25:37'),
  ('RETO15D-castri-llon@hotmail.com', 'PURCHASE_COMPLETE', 'Daniel Castrillon jaramillo', 'castri-llon@hotmail.com', '573006391464', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T22:49:43'),
  ('RETO15D-yanethroam@hotmail.com', 'PURCHASE_COMPLETE', 'ERIKA YANETH ROA MARTINEZ', 'yanethroam@hotmail.com', '573202049026', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-30T23:48:13'),
  ('RETO15D-isandigital2024@gmail.com', 'PURCHASE_COMPLETE', 'Isabela Martinez', 'isandigital2024@gmail.com', '573008147387', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-31T13:09:03'),
  ('RETO15D-catyriveras@gmail.com', 'PURCHASE_COMPLETE', 'catalina rivera sanchez', 'catyriveras@gmail.com', '573137120934', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-31T18:57:48'),
  ('RETO15D-dianicuerv07@gmail.com', 'PURCHASE_COMPLETE', 'Diana Cuervo', 'dianicuerv07@gmail.com', '573214907628', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-31T19:08:31'),
  ('RETO15D-coronado_karl@hotmail.com', 'PURCHASE_COMPLETE', 'Karla Coronado', 'coronado_karl@hotmail.com', '525513924025', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-03-31T19:14:00'),
  ('RETO15D-andrea_sierra16@hotmail.com', 'PURCHASE_COMPLETE', 'María Paula paez', 'andrea_sierra16@hotmail.com', '573112559951', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-31T20:02:51'),
  ('RETO15D-gmgempresas.com@gmail.com', 'PURCHASE_COMPLETE', 'Giovanny Gonzalez', 'gmgempresas.com@gmail.com', '573232849527', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-03-31T20:23:49'),
  ('RETO15D-do72353@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Rusinque', 'do72353@gmail.com', '573158914145', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-31T20:23:30'),
  ('RETO15D-lele-sanchex1@hotmail.com', 'PURCHASE_COMPLETE', 'Celeste Sánchez', 'lele-sanchex1@hotmail.com', '573208199089', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-03-31T20:55:58'),
  ('RETO15D-tradingymas2023@gmail.com', 'PURCHASE_COMPLETE', 'Yuneisi Valdés', 'tradingymas2023@gmail.com', '34673165088', 'ES', 'Reto 15D', 36.78, 'USD', 'active', '2025-04-01T02:39:42'),
  ('RETO15D-dylanincrease@gmail.com', 'PURCHASE_COMPLETE', 'Victor Medina', 'dylanincrease@gmail.com', '528444980359', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-01T04:25:25'),
  ('RETO15D-jximenar1112@gmail.com', 'PURCHASE_COMPLETE', 'Jeime Ximena Rincón Pedraza', 'jximenar1112@gmail.com', '573213598191', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T05:19:31'),
  ('RETO15D-info@marcerrealtor.com', 'PURCHASE_COMPLETE', 'Marcela Otalora', 'info@marcerrealtor.com', '14079903450', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-01T05:45:53'),
  ('RETO15D-francinethemprende@gmail.com', 'PURCHASE_COMPLETE', 'Francineth Giraldo', 'francinethemprende@gmail.com', '573023179099', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T06:35:06'),
  ('RETO15D-marugr.sinergia@gmail.com', 'PURCHASE_COMPLETE', 'Maria Eugenia Gordillo', 'marugr.sinergia@gmail.com', '593984248238', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-01T06:51:01'),
  ('RETO15D-leidixxita-@hotmail.com', 'PURCHASE_COMPLETE', 'Leidy Parada', 'leidixxita-@hotmail.com', '573124696268', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T07:48:57'),
  ('RETO15D-geralgonzalez2120@hotmail.com', 'PURCHASE_COMPLETE', 'Geraldin gonzalez', 'geralgonzalez2120@hotmail.com', '573107668619', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T08:44:38'),
  ('RETO15D-nicoleorejuela@icloud.com', 'PURCHASE_COMPLETE', 'Nicole Orejuela', 'nicoleorejuela@icloud.com', '5930981724434', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-01T09:36:20'),
  ('RETO15D-luciannohill@gmail.com', 'PURCHASE_COMPLETE', 'Gabriel Munoz munoz Camacho', 'luciannohill@gmail.com', '573165361090', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T10:05:18'),
  ('RETO15D-maribel311216@gmail.com', 'PURCHASE_COMPLETE', 'Maribel Escobar', 'maribel311216@gmail.com', '573001353534', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T11:58:50'),
  ('RETO15D-leydypaolagarciacelys1994@gmail.com', 'PURCHASE_COMPLETE', 'Leydy paola garcia', 'leydypaolagarciacelys1994@gmail.com', '573112643982', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T19:29:22'),
  ('RETO15D-katerinemorales1731@gmail.com', 'PURCHASE_COMPLETE', 'Katerine Morales', 'katerinemorales1731@gmail.com', '573166449602', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T20:38:18'),
  ('RETO15D-valesm09@hotmail.com', 'PURCHASE_COMPLETE', 'Valentina Suarez', 'valesm09@hotmail.com', '573506799441', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-01T21:39:16'),
  ('RETO15D-crushcalderon635@gmail.com', 'PURCHASE_COMPLETE', 'Liliana calderon martinez', 'crushcalderon635@gmail.com', '16083987131', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-01T21:55:28'),
  ('RETO15D-kattygutierrezr.gdh@gmail.com', 'PURCHASE_COMPLETE', 'Katty Gutiérrez', 'kattygutierrezr.gdh@gmail.com', '5930996220150', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-01T22:08:24'),
  ('RETO15D-angelik_mrm@hotmail.com', 'PURCHASE_COMPLETE', 'Angelica Rodríguez', 'angelik_mrm@hotmail.com', '573112823774', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-02T07:19:56'),
  ('RETO15D-marialegtz@gmail.com', 'PURCHASE_COMPLETE', 'Maria Alejandra Gutierrez De Piñeres', 'marialegtz@gmail.com', '573022319483', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-02T09:39:55'),
  ('RETO15D-ujohana@hotmail.com', 'PURCHASE_COMPLETE', 'Kelly johana Uribe agudelo', 'ujohana@hotmail.com', '573146323892', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-02T10:23:14'),
  ('RETO15D-anita.erira12@gmail.com', 'PURCHASE_COMPLETE', 'Anita Mercedes Erira Aza', 'anita.erira12@gmail.com', '573178638925', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-02T12:58:43'),
  ('RETO15D-obethcelio29@gmail.com', 'PURCHASE_COMPLETE', 'OBETH CELIO HUAMAN HUANCA', 'obethcelio29@gmail.com', '51912842715', 'PE', 'Reto 15D', 37.28, 'USD', 'active', '2025-04-02T14:14:40'),
  ('RETO15D-tatilamprea02@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Lamprea ochoa', 'tatilamprea02@gmail.com', '573183373946', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-02T14:51:39'),
  ('RETO15D-tativ215@gmail.com', 'PURCHASE_COMPLETE', 'TATIANA vargas', 'tativ215@gmail.com', '573138866792', 'CO', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-02T15:34:09'),
  ('RETO15D-antovalencia12@hotmail.com', 'PURCHASE_COMPLETE', 'Antonela Valencia', 'antovalencia12@hotmail.com', '593987146108', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-02T17:04:13'),
  ('RETO15D-jennifer_wk@yahoo.com.co', 'PURCHASE_COMPLETE', 'Liliana Espinosa', 'jennifer_wk@yahoo.com.co', '573103047553', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-02T19:10:07'),
  ('RETO15D-smmb24@gmail.com', 'PURCHASE_COMPLETE', 'Stephany Martinez', 'smmb24@gmail.com', '573008909686', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-02T19:34:56'),
  ('RETO15D-juandaramirez1983@gmail.com', 'PURCHASE_COMPLETE', 'Juan David Ramírez', 'juandaramirez1983@gmail.com', '573006967776', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-02T20:18:29'),
  ('RETO15D-marianaflorezu@gmail.com', 'PURCHASE_COMPLETE', 'Mariana Flórez Urrego', 'marianaflorezu@gmail.com', '573007246984', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-02T21:53:15'),
  ('RETO15D-agenciatravelsai@gmail.com', 'PURCHASE_COMPLETE', 'Zayda molina', 'agenciatravelsai@gmail.com', '5713214094508', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-03T07:41:46'),
  ('RETO15D-vivianagiraldop85@gmail.com', 'PURCHASE_COMPLETE', 'Viviana Giraldo', 'vivianagiraldop85@gmail.com', '51933592688', 'PE', 'Reto 15D', 37.26, 'USD', 'active', '2025-04-03T08:09:29'),
  ('RETO15D-estefania_2709@hotmail.com', 'PURCHASE_COMPLETE', 'Estefania López', 'estefania_2709@hotmail.com', '573104954807', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T08:38:41'),
  ('RETO15D-nurypacheco25@hotmail.com', 'PURCHASE_COMPLETE', 'Nury pacheco', 'nurypacheco25@hotmail.com', '573172451357', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T08:33:14'),
  ('RETO15D-andreaherrera8921@gmail.com', 'PURCHASE_COMPLETE', 'Nelfry herrera', 'andreaherrera8921@gmail.com', '117204837683', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-03T10:36:40'),
  ('RETO15D-kimfloresv@gmail.com', 'PURCHASE_COMPLETE', 'Kimberling Flores', 'kimfloresv@gmail.com', '51932374536', 'PE', 'Reto 15D', 37.26, 'USD', 'active', '2025-04-03T10:38:34'),
  ('RETO15D-luisavasquezcomunicadora@gmail.com', 'PURCHASE_COMPLETE', 'Luisa fernanda vasquez cuartas', 'luisavasquezcomunicadora@gmail.com', '573233270116', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T11:01:52'),
  ('RETO15D-gelatoitalianoartesanal@gmail.com', 'PURCHASE_COMPLETE', 'Fabrizio Scribante', 'gelatoitalianoartesanal@gmail.com', '524341440924', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-04-03T15:11:01'),
  ('RETO15D-perlanc.cursos@gmail.com', 'PURCHASE_COMPLETE', 'Perla Navarro', 'perlanc.cursos@gmail.com', '523312984009', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-03T17:17:26'),
  ('RETO15D-stivenbl517@gmail.com', 'PURCHASE_COMPLETE', 'Luis Stiven balsero lopez', 'stivenbl517@gmail.com', '573218350631', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-03T17:25:41'),
  ('RETO15D-miopticag.o@gmail.com', 'PURCHASE_COMPLETE', 'Greisy osma', 'miopticag.o@gmail.com', '573214999531', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T19:25:34'),
  ('RETO15D-rocketeamproducciones@gmail.com', 'PURCHASE_COMPLETE', 'RAMON ANDRES MOROS ORTIZ', 'rocketeamproducciones@gmail.com', '573043432095', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T19:41:53'),
  ('RETO15D-espinolafigueroajesusleonel@gmail.com', 'PURCHASE_COMPLETE', 'Jesus Espinola', 'espinolafigueroajesusleonel@gmail.com', '14075387085', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-03T20:52:50'),
  ('RETO15D-alejandromedinaiin@gmail.com', 'PURCHASE_COMPLETE', 'Alejandro Medina Medina', 'alejandromedinaiin@gmail.com', '573136242318', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T22:46:56'),
  ('RETO15D-kevinmontesdeocarivas@gmail.com', 'PURCHASE_COMPLETE', 'Kevin montes de oca', 'kevinmontesdeocarivas@gmail.com', '573182422441', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-03T23:04:50'),
  ('RETO15D-marthameru22@gmail.com', 'PURCHASE_COMPLETE', 'Martha Eugenia Meza Ruiz', 'marthameru22@gmail.com', '523881051843', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-03T23:49:50'),
  ('RETO15D-mikealfonsomusic@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Alfonso Rodriguez', 'mikealfonsomusic@gmail.com', '573124181836', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-04T05:45:24'),
  ('RETO15D-caenthi0502@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Rausseo', 'caenthi0502@gmail.com', '34664199489', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-04T06:17:47'),
  ('RETO15D-dannyluque123@gmail.com', 'PURCHASE_COMPLETE', 'Danny Luque lopez', 'dannyluque123@gmail.com', '573244556316', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-04T08:41:17'),
  ('RETO15D-cadete711@gmail.com', 'PURCHASE_COMPLETE', 'Victor lopez', 'cadete711@gmail.com', '573184079261', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-04T10:52:51'),
  ('RETO15D-sugey_1279@hotmail.com', 'PURCHASE_COMPLETE', 'Sugey Giraldo', 'sugey_1279@hotmail.com', '573125343336', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-04T08:28:14'),
  ('RETO15D-diegoupel35@gmail.com', 'PURCHASE_COMPLETE', 'Diego Rodriguez', 'diegoupel35@gmail.com', '584243424307', 'VE', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-04T14:17:37'),
  ('RETO15D-lauranicoll.chacon@gmail.com', 'PURCHASE_COMPLETE', 'Laura Nicoll Chacon Forero', 'lauranicoll.chacon@gmail.com', '573022408482', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-04T14:42:17'),
  ('RETO15D-ajolon@gmail.com', 'PURCHASE_COMPLETE', 'Jose Jolon', 'ajolon@gmail.com', '50253010151', 'GT', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-04T16:20:19'),
  ('RETO15D-carvajalm295@gmail.com', 'PURCHASE_COMPLETE', 'Mayra alejandra carvajal carrillo', 'carvajalm295@gmail.com', '573212703682', 'UY', 'Reto 15D', 36.94, 'USD', 'active', '2025-04-04T16:39:42'),
  ('RETO15D-josemiguelfbz337@gmail.com', 'PURCHASE_COMPLETE', 'José Miguel Torres Torres', 'josemiguelfbz337@gmail.com', '573117388183', 'CO', 'Reto 15D', 20251021000000, 'USD', 'active', '2025-04-04T17:36:49'),
  ('RETO15D-jonathan.d.12@hotmail.com', 'PURCHASE_COMPLETE', 'Jonathan david Vargas piedrahita', 'jonathan.d.12@hotmail.com', '573118012006', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-04T21:38:50'),
  ('RETO15D-alvarez.pao@gmail.com', 'PURCHASE_COMPLETE', 'Paola Alvarez', 'alvarez.pao@gmail.com', '573003082232', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T04:58:03'),
  ('RETO15D-mporritasg@gmail.com', 'PURCHASE_COMPLETE', 'Magda Porras', 'mporritasg@gmail.com', '573118359706', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T07:56:11'),
  ('RETO15D-pardok94@gmail.com', 'PURCHASE_COMPLETE', 'Kevin jose Pardo lopez', 'pardok94@gmail.com', '573224544507', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T08:09:12'),
  ('RETO15D-esperanza@ehopeusa.com', 'PURCHASE_COMPLETE', 'Esperanza Bustamante', 'esperanza@ehopeusa.com', '12393166751', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-05T09:10:34'),
  ('RETO15D-jeniferisazaluna@gmail.com', 'PURCHASE_COMPLETE', 'Jenifer Isaza Luna', 'jeniferisazaluna@gmail.com', '573028549767', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T09:14:07'),
  ('RETO15D-dianaarizam87@gmail.com', 'PURCHASE_COMPLETE', 'Diana Ariza', 'dianaarizam87@gmail.com', '573113974590', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T10:43:40'),
  ('RETO15D-karyviqueira@gmail.com', 'PURCHASE_COMPLETE', 'Karina Viqueira', 'karyviqueira@gmail.com', '541149796095', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-04-05T12:28:09'),
  ('RETO15D-susanabarahona21@gmail.com', 'PURCHASE_COMPLETE', 'Susana Barahona', 'susanabarahona21@gmail.com', '573028067914', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T13:03:46'),
  ('RETO15D-koke.macias@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Macias', 'koke.macias@gmail.com', '526319448651', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T14:30:29'),
  ('RETO15D-sandraurqui1@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Urquijo', 'sandraurqui1@gmail.com', '573154846949', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T15:30:19'),
  ('RETO15D-beraguirre@gmail.com', 'PURCHASE_COMPLETE', 'Bernardita Aguirre', 'beraguirre@gmail.com', '56992388751', 'CL', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-05T18:05:21'),
  ('RETO15D-activalamujer@hotmail.com', 'PURCHASE_COMPLETE', 'sandra Ramón', 'activalamujer@hotmail.com', '529989393309', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-04-05T18:23:56'),
  ('RETO15D-jenniferquimbayo92@gmail.com', 'PURCHASE_COMPLETE', 'Jennifer quimbayo', 'jenniferquimbayo92@gmail.com', '573002523226', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T19:25:56'),
  ('RETO15D-cordovaalejandra29@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Cordova Murillo', 'cordovaalejandra29@gmail.com', '525541301089', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-04-05T22:22:09'),
  ('RETO15D-misabelvillar@hotmail.com', 'PURCHASE_COMPLETE', 'Isabel Villa', 'misabelvillar@hotmail.com', '527773521232', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-04-05T22:25:30'),
  ('RETO15D-gabriel.cifuentes.m@gmail.com', 'PURCHASE_COMPLETE', 'Gabriel Cifuentes', 'gabriel.cifuentes.m@gmail.com', '5930992738412', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-05T22:38:07'),
  ('RETO15D-academy777lhm@gmail.com', 'PURCHASE_COMPLETE', 'Luis Hernando Medrano', 'academy777lhm@gmail.com', '573014221333', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-05T22:57:01'),
  ('RETO15D-marielapollastrini18@gmail.com', 'PURCHASE_COMPLETE', 'Mariela Pollastrini', 'marielapollastrini18@gmail.com', '14423726101', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-05T23:25:28'),
  ('RETO15D-solucionmaldonado67@gmail.com', 'PURCHASE_COMPLETE', 'Luis Suarez', 'solucionmaldonado67@gmail.com', '19852556877', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-06T00:06:59'),
  ('RETO15D-kathy_sofi95@hotmail.com', 'PURCHASE_COMPLETE', 'Katheryn Sofia Temoche', 'kathy_sofi95@hotmail.com', '51980176796', 'PE', 'Reto 15D', 37.19, 'USD', 'active', '2025-04-06T00:41:10'),
  ('RETO15D-boriscometta27@gmail.com', 'PURCHASE_COMPLETE', 'Boris cometta', 'boriscometta27@gmail.com', '573132330831', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T06:18:12'),
  ('RETO15D-opticanewtonsa@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Liliana Martinez Quintero', 'opticanewtonsa@gmail.com', '573005544038', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T09:26:53'),
  ('RETO15D-lauryrua95@gmail.com', 'PURCHASE_COMPLETE', 'Laury Rua', 'lauryrua95@gmail.com', '573007896158', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T09:59:12'),
  ('RETO15D-alberto_acosta1@hotmail.com', 'PURCHASE_COMPLETE', 'Alberto Acosta', 'alberto_acosta1@hotmail.com', '573188833566', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T10:28:48'),
  ('RETO15D-nataliahl2010@hotmail.com', 'PURCHASE_COMPLETE', 'Olga Hernandez', 'nataliahl2010@hotmail.com', '573116511890', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T11:03:18'),
  ('RETO15D-topteninmobiliaria55@gmail.com', 'PURCHASE_COMPLETE', 'Don José', 'topteninmobiliaria55@gmail.com', '525298438506', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-04-06T11:49:23'),
  ('RETO15D-pablocelis11@gmail.com', 'PURCHASE_COMPLETE', 'Pablo Celis', 'pablocelis11@gmail.com', '573182669762', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T12:43:01'),
  ('RETO15D-karendiazm@hotmail.com', 'PURCHASE_COMPLETE', 'Karen Diaz', 'karendiazm@hotmail.com', '573125103296', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T15:03:18'),
  ('RETO15D-hoyosjeimy96@gmail.com', 'PURCHASE_COMPLETE', 'Jeimy echeverry', 'hoyosjeimy96@gmail.com', '573235413045', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-06T15:33:45'),
  ('RETO15D-yeshuarodriguezsilva@gmail.com', 'PURCHASE_COMPLETE', 'Yeshua Rodriguez', 'yeshuarodriguezsilva@gmail.com', '525581204019', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-06T21:15:39'),
  ('RETO15D-xp.yar4@gmail.com', 'PURCHASE_COMPLETE', 'Yarmila Marianela Hinojosa Fernandez', 'xp.yar4@gmail.com', '59169888518', 'BO', 'Reto 15D', 36.96, 'USD', 'active', '2025-04-06T23:03:57'),
  ('RETO15D-adoariza05@gmail.com', 'PURCHASE_COMPLETE', 'Adolfina Ariza Herrera', 'adoariza05@gmail.com', '19372503165', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-07T04:42:38'),
  ('RETO15D-jorgefilmmaking@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Luis Muñoz Pinto', 'jorgefilmmaking@gmail.com', '573104013025', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T09:06:15'),
  ('RETO15D-caroll91rodriguez@gmail.com', 'PURCHASE_COMPLETE', 'Marlenny Domínguez Mengo', 'caroll91rodriguez@gmail.com', '117707659637', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-07T10:10:10'),
  ('RETO15D-gercysimet8@gmail.com', 'PURCHASE_COMPLETE', 'Gercy simet', 'gercysimet8@gmail.com', '19293842085', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-07T12:41:38'),
  ('RETO15D-dimaleva_58@hotmail.com', 'PURCHASE_COMPLETE', 'Diana Maria Leyva Vargas', 'dimaleva_58@hotmail.com', '573115817242', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T14:13:31'),
  ('RETO15D-camiloandresp19@hotmail.com', 'PURCHASE_COMPLETE', 'Camilo Andres Patiño Mesa', 'camiloandresp19@hotmail.com', '573106821329', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T14:35:07'),
  ('RETO15D-banuelosmd@gmail.com', 'PURCHASE_COMPLETE', 'Sr JESUS BANUELOS', 'banuelosmd@gmail.com', '523314271361', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T14:55:13'),
  ('RETO15D-tarangoplay@gmail.com', 'PURCHASE_COMPLETE', 'Valentina Hincapié', 'tarangoplay@gmail.com', '573173662555', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T15:00:30'),
  ('RETO15D-andreaceh16@gmail.com', 'PURCHASE_COMPLETE', 'Andrea Escobar Herrera', 'andreaceh16@gmail.com', '573046528230', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-07T18:11:25'),
  ('RETO15D-alejo20j@gmail.com', 'PURCHASE_COMPLETE', 'Alejandro Montoya', 'alejo20j@gmail.com', '573216074698', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T21:00:20'),
  ('RETO15D-vivianasamaniego1283@gmail.com', 'PURCHASE_COMPLETE', 'viviana Samaniego Hoyos', 'vivianasamaniego1283@gmail.com', '573161868652', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T21:13:25'),
  ('RETO15D-rbnguillermo@gmail.com', 'PURCHASE_COMPLETE', 'rubenb guillermo ccapa huaricallo', 'rbnguillermo@gmail.com', '51958232512', 'PE', 'Reto 15D', 37.34, 'USD', 'active', '2025-04-07T21:29:23'),
  ('RETO15D-santyadss@gmail.com', 'PURCHASE_COMPLETE', 'Santiago Muñoz Pineda', 'santyadss@gmail.com', '573205832381', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T22:21:44'),
  ('RETO15D-biscuerobayo@hotmail.com', 'PURCHASE_COMPLETE', 'Jaiver Biscue', 'biscuerobayo@hotmail.com', '573226864242', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-07T22:27:29'),
  ('RETO15D-andrea@andreaodle.com', 'PURCHASE_COMPLETE', 'Andrea Odle', 'andrea@andreaodle.com', '16617091497', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-07T23:24:35'),
  ('RETO15D-acuerdosfinancierosldc@gmail.com', 'PURCHASE_COMPLETE', 'Luis David Caselles Rodriguez', 'acuerdosfinancierosldc@gmail.com', '573218391103', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-08T06:38:02'),
  ('RETO15D-steffy.veliz23@gmail.com', 'PURCHASE_COMPLETE', 'Steffy Veliz', 'steffy.veliz23@gmail.com', '13855296273', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-08T07:05:09'),
  ('RETO15D-coordinacioneventosvictoria@gmail.com', 'PURCHASE_COMPLETE', 'Victoria Osorio santofimio', 'coordinacioneventosvictoria@gmail.com', '573176994066', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-08T08:05:28'),
  ('RETO15D-jefferson.marben10@gmail.com', 'PURCHASE_COMPLETE', 'Jefferson Martinez Benitez', 'jefferson.marben10@gmail.com', '573116085130', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-08T13:07:58'),
  ('RETO15D-kte-navarro@hotmail.com', 'PURCHASE_COMPLETE', 'Katherine Navarro', 'kte-navarro@hotmail.com', '573104657741', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-08T14:34:47'),
  ('RETO15D-paulitha3110@gmail.com', 'PURCHASE_COMPLETE', 'Paula Andrea Garzón', 'paulitha3110@gmail.com', '573215705302', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-08T15:27:52'),
  ('RETO15D-angelacusco2019@gmail.com', 'PURCHASE_COMPLETE', 'ANGELA RIVERA', 'angelacusco2019@gmail.com', '51958192800', 'PE', 'Reto 15D', 37.34, 'USD', 'active', '2025-04-08T15:29:32'),
  ('RETO15D-gromit4800@gmail.com', 'PURCHASE_COMPLETE', 'Jonathan Orduño molina', 'gromit4800@gmail.com', '525663720279', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-04-08T16:09:28'),
  ('RETO15D-hmolanopatino@gmail.com', 'PURCHASE_COMPLETE', 'Holman molano patino', 'hmolanopatino@gmail.com', '573012061436', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-08T23:14:27'),
  ('RETO15D-armandochazari@gmail.com', 'PURCHASE_COMPLETE', 'Gerardo Chazarí', 'armandochazari@gmail.com', '14259037534', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-09T00:02:43'),
  ('RETO15D-brepaca725@gmail.com', 'PURCHASE_COMPLETE', 'Brenda Palacio Carrasquilla', 'brepaca725@gmail.com', '573169369763', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T07:40:43'),
  ('RETO15D-jenny.povedar@gmail.com', 'PURCHASE_COMPLETE', 'Yenny Alexandra Poveda Rincón', 'jenny.povedar@gmail.com', '573212723732', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T07:57:44'),
  ('RETO15D-ceojairoavalos@gmail.com', 'PURCHASE_COMPLETE', 'Jairo Avalos', 'ceojairoavalos@gmail.com', '525625294651', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-04-09T08:08:36'),
  ('RETO15D-lozano_702@hotmail.com', 'PURCHASE_COMPLETE', 'JESUS LOZANO', 'lozano_702@hotmail.com', '528123330440', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-04-09T08:59:08'),
  ('RETO15D-adricaballero10@hotmail.com', 'PURCHASE_COMPLETE', 'Adriana Caballero', 'adricaballero10@hotmail.com', '573102822746', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T09:06:12'),
  ('RETO15D-sebasrojasm@gmail.com', 'PURCHASE_COMPLETE', 'Juan sebastian Rojas martinez', 'sebasrojasm@gmail.com', '573137433478', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T10:48:50'),
  ('RETO15D-nicolshopiavanegasarenas@gmail.com', 'PURCHASE_COMPLETE', 'Nicol Sofia Vanegas Arenas', 'nicolshopiavanegasarenas@gmail.com', '573222352510', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T14:49:49'),
  ('RETO15D-sindyanez05@gmail.com', 'PURCHASE_COMPLETE', 'Cindy Yanez', 'sindyanez05@gmail.com', '573016237237', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T17:44:26'),
  ('RETO15D-lore.leon2412@gmail.com', 'PURCHASE_COMPLETE', 'Loreana Villabona', 'lore.leon2412@gmail.com', '573225875438', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-09T22:12:06'),
  ('RETO15D-info@samuelfranco.com', 'PURCHASE_COMPLETE', 'Samuel Franco', 'info@samuelfranco.com', '573153113232', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-10T05:48:04'),
  ('RETO15D-gustavoguerraventas@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Guerra ventas', 'gustavoguerraventas@gmail.com', '573133224392', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-10T09:50:53'),
  ('RETO15D-opt.a_armendariz@outlook.com', 'PURCHASE_COMPLETE', 'Anabel Alexandra Armendariz Velasquez', 'opt.a_armendariz@outlook.com', '5930996258531', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-10T10:13:01'),
  ('RETO15D-asanchezp1974@gmail.com', 'PURCHASE_COMPLETE', 'Andre Sanchez', 'asanchezp1974@gmail.com', '56975395383', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-10T16:22:05'),
  ('RETO15D-concejalnicolas@gmail.com', 'PURCHASE_COMPLETE', 'Nicolas Sanchez', 'concejalnicolas@gmail.com', '573184042381', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-10T23:13:07'),
  ('RETO15D-modebonilla@cococreativo.com.mx', 'PURCHASE_COMPLETE', 'Modesto Bonilla', 'modebonilla@cococreativo.com.mx', '522281731761', 'MX', 'Reto 15D', 37.02, 'USD', 'active', '2025-04-11T08:45:19'),
  ('RETO15D-anagaviriar05@gmail.com', 'PURCHASE_COMPLETE', 'Ana Maria Gaviria Ramirez', 'anagaviriar05@gmail.com', '573022542072', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-11T12:08:47'),
  ('RETO15D-m.jair2819@gmail.com', 'PURCHASE_COMPLETE', 'Marcos Cuervo', 'm.jair2819@gmail.com', '573123178293', 'CO', 'Reto 15D', 36.54, 'USD', 'active', '2025-04-12T15:36:49'),
  ('RETO15D-sxmauroxe@gmail.com', 'PURCHASE_COMPLETE', 'Mauricio Velez rojas', 'sxmauroxe@gmail.com', '573225134997', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-14T14:26:14'),
  ('RETO15D-jart85@gmail.com', 'PURCHASE_COMPLETE', 'Javiana Artuza', 'jart85@gmail.com', '573042441106', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-14T19:45:02'),
  ('RETO15D-jmendezcalle@yahoo.com', 'PURCHASE_COMPLETE', 'Jennyfer Méndez', 'jmendezcalle@yahoo.com', '593958647103', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-15T06:42:38'),
  ('RETO15D-gerencia@atiempo.com.ec', 'PURCHASE_COMPLETE', 'Roberto Leon', 'gerencia@atiempo.com.ec', '593988985500', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-15T08:02:55'),
  ('RETO15D-bluagencia2021@gmail.com', 'PURCHASE_COMPLETE', 'Andres Godoy', 'bluagencia2021@gmail.com', '573125883339', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-15T09:02:57'),
  ('RETO15D-glendafernandez777@icloud.com', 'PURCHASE_COMPLETE', 'Glenda jucceli fernandez lizarraga', 'glendafernandez777@icloud.com', '573106087542', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-15T10:36:02'),
  ('RETO15D-cpn.hugosolalinde@gmail.com', 'PURCHASE_COMPLETE', 'Hugo Solalinde', 'cpn.hugosolalinde@gmail.com', '595975485392', 'PY', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-15T12:11:45'),
  ('RETO15D-gomezmilena781@gmail.com', 'PURCHASE_COMPLETE', 'Milena Gómez', 'gomezmilena781@gmail.com', '573128867937', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-15T14:29:23'),
  ('RETO15D-felipedr161@hotmail.com', 'PURCHASE_COMPLETE', 'Felipe Davila Rojas', 'felipedr161@hotmail.com', '573108671712', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-15T17:10:33'),
  ('RETO15D-jhonyquevedo@gmail.com', 'PURCHASE_COMPLETE', 'JHONATAN SEBASTIAN QUEVEDO JIMENEZ', 'jhonyquevedo@gmail.com', '573204792521', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-15T21:42:41'),
  ('RETO15D-alojah83@gmail.com', 'PURCHASE_COMPLETE', 'Adriana LOJA', 'alojah83@gmail.com', '19146022108', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-15T22:00:14'),
  ('RETO15D-marceco1975@hotmail.com', 'PURCHASE_COMPLETE', 'Marcela Correa', 'marceco1975@hotmail.com', '573217294172', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-16T07:26:42'),
  ('RETO15D-hernandezmartinezalexis@gmail.com', 'PURCHASE_COMPLETE', 'Alexis Hernandez Martinez', 'hernandezmartinezalexis@gmail.com', '573112307733', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-16T10:26:04'),
  ('RETO15D-caprietos@yahoo.com', 'PURCHASE_COMPLETE', 'Carlos Alberto Prieto', 'caprietos@yahoo.com', '573116007486', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-16T14:31:50'),
  ('RETO15D-lizeth27642@hotmail.com', 'PURCHASE_COMPLETE', 'Lizeth Castro Yepes', 'lizeth27642@hotmail.com', '573102962419', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-16T18:34:54'),
  ('RETO15D-sebastianrc15.2@gmail.com', 'PURCHASE_COMPLETE', 'Sebastian Cardona', 'sebastianrc15.2@gmail.com', '524191562539', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-04-17T00:07:37'),
  ('RETO15D-hortensia@encasapanama.com', 'PURCHASE_COMPLETE', 'Hortensia Allen', 'hortensia@encasapanama.com', '50760914187', 'PA', 'Reto 15D', 37.00, 'USD', 'active', '2025-04-17T05:52:56'),
  ('RETO15D-lewistrp@gmail.com', 'PURCHASE_COMPLETE', 'Lewis Pineda', 'lewistrp@gmail.com', '573116962961', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-17T07:05:43'),
  ('RETO15D-diana19484@hotmail.com', 'PURCHASE_COMPLETE', 'Diana Sango', 'diana19484@hotmail.com', '5930939077389', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-17T08:15:32'),
  ('RETO15D-osiris1323@yahoo.com', 'PURCHASE_COMPLETE', 'Celso Santana Flores', 'osiris1323@yahoo.com', '527224587632', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-04-17T09:58:58'),
  ('RETO15D-denegociosco@gmail.com', 'PURCHASE_COMPLETE', 'Edgar Ruiz', 'denegociosco@gmail.com', '573153540285', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-17T14:40:55'),
  ('RETO15D-aleparraduque@gmail.com', 'PURCHASE_COMPLETE', 'alejandro parra', 'aleparraduque@gmail.com', '573216044646', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-17T21:53:21'),
  ('RETO15D-paulaguarnido15@gmail.com', 'PURCHASE_COMPLETE', 'Paula Guarnido', 'paulaguarnido15@gmail.com', '542645081467', 'AR', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-17T22:06:54'),
  ('RETO15D-juanpablo.g@solucioneseducativastc.com', 'PURCHASE_COMPLETE', 'Juan Pablo Garzón', 'juanpablo.g@solucioneseducativastc.com', '5930998345612', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-17T23:09:19'),
  ('RETO15D-henryquilind58@gmail.com', 'PURCHASE_COMPLETE', 'Henry Quilindo', 'henryquilind58@gmail.com', '573001349138', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-17T23:56:51'),
  ('RETO15D-johan078colombia@hotmail.com', 'PURCHASE_COMPLETE', 'Johan esteban ortiz mesa', 'johan078colombia@hotmail.com', '573006466946', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-18T00:27:45'),
  ('RETO15D-jcamiloaga@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Camiloaga', 'jcamiloaga@gmail.com', '51966786221', 'CO', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-18T07:51:50'),
  ('RETO15D-dianalucia2021@yahoo.com', 'PURCHASE_COMPLETE', 'Diana Bueno', 'dianalucia2021@yahoo.com', '573162824755', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-18T08:05:24'),
  ('RETO15D-jmalvarez@catalizando.com', 'PURCHASE_COMPLETE', 'Juan Manuel', 'jmalvarez@catalizando.com', '17868458828', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-18T08:59:55'),
  ('RETO15D-lauravanessa.marquezc@gmail.com', 'PURCHASE_COMPLETE', 'Laura Vanessa mARQUEZ', 'lauravanessa.marquezc@gmail.com', '573212364132', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-18T13:20:47'),
  ('RETO15D-rlgladys258@gmail.com', 'PURCHASE_COMPLETE', 'Gladys Rodriguez', 'rlgladys258@gmail.com', '573002489514', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-18T21:57:11'),
  ('RETO15D-drgarcia.emprende@gmail.com', 'PURCHASE_COMPLETE', 'Alberto Jose Garcia', 'drgarcia.emprende@gmail.com', '50660192493', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-18T22:26:55'),
  ('RETO15D-tefagomez.art@gmail.com', 'PURCHASE_COMPLETE', 'Estefania Gomez', 'tefagomez.art@gmail.com', '573158026471', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-19T07:27:36'),
  ('RETO15D-andres7max@gmail.com', 'PURCHASE_COMPLETE', 'Fabian Moreno', 'andres7max@gmail.com', '573187151864', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-19T08:11:56'),
  ('RETO15D-ger061136@gmail.com', 'PURCHASE_COMPLETE', 'German Andres Salamanca Medina', 'ger061136@gmail.com', '573215751860', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-19T10:08:21'),
  ('RETO15D-tomassisa72@gmail.com', 'PURCHASE_COMPLETE', 'Tomas Giraldo', 'tomassisa72@gmail.com', '573128013063', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-19T13:40:30'),
  ('RETO15D-caprichosspa2019@gmail.com', 'PURCHASE_COMPLETE', 'Carol Briñez', 'caprichosspa2019@gmail.com', '573214379408', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-20T06:25:31'),
  ('RETO15D-jorgerodriguezinvestment@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Rodriguez', 'jorgerodriguezinvestment@gmail.com', '19499663623', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-20T08:22:05'),
  ('RETO15D-josegplazas@gmail.com', 'PURCHASE_COMPLETE', 'Jose plaza', 'josegplazas@gmail.com', '573008173434', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-20T09:02:25'),
  ('RETO15D-dropshippingecommercemastery@gmail.com', 'PURCHASE_COMPLETE', 'Juan camilo', 'dropshippingecommercemastery@gmail.com', '573183889957', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-20T10:52:40'),
  ('RETO15D-morenoricardo848@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo moreno', 'morenoricardo848@gmail.com', '573175406827', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-20T12:47:31'),
  ('RETO15D-oscarmau1@outlook.com', 'PURCHASE_COMPLETE', 'Mauricio Mayorga', 'oscarmau1@outlook.com', '573213353561', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-20T13:22:22'),
  ('RETO15D-marthaostios@hotmail.com', 'PURCHASE_COMPLETE', 'Yamile ostios', 'marthaostios@hotmail.com', '593995071106', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-20T14:03:15'),
  ('RETO15D-impulsa_markting1.0@gmail.com', 'PURCHASE_COMPLETE', 'Ylendi Samboni', 'impulsa_markting1.0@gmail.com', '573196209866', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-20T16:32:23'),
  ('RETO15D-saavedra.ro75@gmail.com', 'PURCHASE_COMPLETE', 'Roberto César Saavedra Rengifo', 'saavedra.ro75@gmail.com', '51975356830', 'PE', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-20T21:53:09'),
  ('RETO15D-kevinfpa1406@gmail.com', 'PURCHASE_COMPLETE', 'kevin carmona pajaro', 'kevinfpa1406@gmail.com', '573108352138', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T14:25:05'),
  ('RETO15D-sanchez_laura.h@hotmail.com', 'PURCHASE_COMPLETE', 'Laura Ximena Sanchez', 'sanchez_laura.h@hotmail.com', '573222822505', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T14:57:09'),
  ('RETO15D-heiber025@gmail.com', 'PURCHASE_COMPLETE', 'Heiber Rojas Martinez', 'heiber025@gmail.com', '573002975058', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T15:19:52'),
  ('RETO15D-eventosclubdecampolipangue@gmail.com', 'PURCHASE_COMPLETE', 'Paula Quintanilla', 'eventosclubdecampolipangue@gmail.com', '56988329799', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T18:06:00'),
  ('RETO15D-euvivolavida@hotmail.com', 'PURCHASE_COMPLETE', 'falon murillo', 'euvivolavida@hotmail.com', '573175577427', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T18:40:52'),
  ('RETO15D-lizbethdvand@gmail.com', 'PURCHASE_COMPLETE', 'Lizbeth rativa salas', 'lizbethdvand@gmail.com', '573246433848', 'PY', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T19:06:04'),
  ('RETO15D-yurani2102jeronimo@gmail.com', 'PURCHASE_COMPLETE', 'Yurani navarro Rodríguez', 'yurani2102jeronimo@gmail.com', '573108354852', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T20:12:45'),
  ('RETO15D-duqueandrea079@gmail.com', 'PURCHASE_COMPLETE', 'Karina Andrea Duque Suarez', 'duqueandrea079@gmail.com', '573146649111', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T21:00:32'),
  ('RETO15D-fabian.gacosta@gmail.com', 'PURCHASE_COMPLETE', 'Fabian Gutiérrez', 'fabian.gacosta@gmail.com', '573133202100', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-21T21:49:52'),
  ('RETO15D-danimosidj@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Mosquera', 'danimosidj@gmail.com', '573103357439', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T06:50:47'),
  ('RETO15D-andres580357@gmail.com', 'PURCHASE_COMPLETE', 'Andres prada', 'andres580357@gmail.com', '573124249406', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T07:15:49'),
  ('RETO15D-celecomunica@gmail.com', 'PURCHASE_COMPLETE', 'Ana Celene Posada Plaza', 'celecomunica@gmail.com', '573012351782', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T07:21:48'),
  ('RETO15D-yuryjimenez@gmail.com', 'PURCHASE_COMPLETE', 'Yury alexandra', 'yuryjimenez@gmail.com', '573007795209', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T09:28:41'),
  ('RETO15D-behappynailscl@gmail.com', 'PURCHASE_COMPLETE', 'BE HAPPY NAILS SPA', 'behappynailscl@gmail.com', '56961447426', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T10:57:38'),
  ('RETO15D-marketingllado@gmail.com', 'PURCHASE_COMPLETE', 'KAREN LLADO', 'marketingllado@gmail.com', '573122655647', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T11:42:39'),
  ('RETO15D-joelmejia708@gmail.com', 'PURCHASE_COMPLETE', 'Joel Mejia Parias', 'joelmejia708@gmail.com', '51981753369', 'PE', 'Reto 15D', 37.04, 'USD', 'active', '2025-04-22T19:05:13'),
  ('RETO15D-kristhina39@hotmail.com', 'PURCHASE_COMPLETE', 'Ana cristina quintero zarama', 'kristhina39@hotmail.com', '573234632921', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-22T19:07:16'),
  ('RETO15D-santicada@gmail.com', 'PURCHASE_COMPLETE', 'Santiago cadavid toro Cadavid toro', 'santicada@gmail.com', '573103329304', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-23T07:29:02'),
  ('RETO15D-rauljtorres18@gmail.com', 'PURCHASE_COMPLETE', 'Raúl Torres', 'rauljtorres18@gmail.com', '51952106194', 'PE', 'Reto 15D', 37.04, 'USD', 'active', '2025-04-23T10:48:43'),
  ('RETO15D-elpandaaoficial@gmail.com', 'PURCHASE_COMPLETE', 'Omar Gutierrez', 'elpandaaoficial@gmail.com', '573219282885', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-23T11:21:06'),
  ('RETO15D-jackfalvarado@gmail.com', 'PURCHASE_COMPLETE', 'Jack Alvarado', 'jackfalvarado@gmail.com', '573165366015', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-23T13:02:16'),
  ('RETO15D-daniela.ortizmedia@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Ortiz Silva', 'daniela.ortizmedia@gmail.com', '573146523709', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-23T15:43:31'),
  ('RETO15D-alejandroartis495@gmail.com', 'PURCHASE_COMPLETE', 'Alejandro Giraldo', 'alejandroartis495@gmail.com', '573227229800', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-23T16:52:45'),
  ('RETO15D-icristina_perezv@hotmail.com', 'PURCHASE_COMPLETE', 'Cristina Pérez', 'icristina_perezv@hotmail.com', '593984692168', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-23T19:22:27'),
  ('RETO15D-kmbmarketing01@gmail.com', 'PURCHASE_COMPLETE', 'KAREN MARCELA VEGA BUITRAGO', 'kmbmarketing01@gmail.com', '573017010008', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-24T04:31:03'),
  ('RETO15D-milezagi@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Milena Zapata Giraldo', 'milezagi@gmail.com', '573218797889', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-24T08:17:26'),
  ('RETO15D-karolinaochoa.ag@gmail.com', 'PURCHASE_COMPLETE', 'Karolina Ochoa', 'karolinaochoa.ag@gmail.com', '573046600022', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-24T08:35:13'),
  ('RETO15D-jdanielrl@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Ramirez', 'jdanielrl@gmail.com', '51940502844', 'PE', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-24T11:03:09'),
  ('RETO15D-lizmanriqueugc@gmail.com', 'PURCHASE_COMPLETE', 'Lizeth Manrique Morales', 'lizmanriqueugc@gmail.com', '573117845634', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-24T18:28:41'),
  ('RETO15D-sandramilenaescobar@hotmail.com', 'PURCHASE_COMPLETE', 'Sandra Escobar', 'sandramilenaescobar@hotmail.com', '573108493687', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-24T19:18:21'),
  ('RETO15D-luferpsicologadigital@gmail.com', 'PURCHASE_COMPLETE', 'Luisa Fernanda Restrepo Rodríguez', 'luferpsicologadigital@gmail.com', '573136861136', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-24T20:48:33'),
  ('RETO15D-fitnessjeikmart@gmail.com', 'PURCHASE_COMPLETE', 'Jeisson Martinez', 'fitnessjeikmart@gmail.com', '573104030814', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-25T01:40:48'),
  ('RETO15D-estheladuchesalazar@gmail.com', 'PURCHASE_COMPLETE', 'Esthela Duche Salazar', 'estheladuchesalazar@gmail.com', '59339823664', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-25T02:28:59'),
  ('RETO15D-coloreartumente@gmail.com', 'PURCHASE_COMPLETE', 'Caren Suarez Monsalve', 'coloreartumente@gmail.com', '573185212402', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-25T07:02:23'),
  ('RETO15D-unasgotasmagicas@gmail.com', 'PURCHASE_COMPLETE', 'Liliana MR', 'unasgotasmagicas@gmail.com', '573154897893', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-25T07:31:48'),
  ('RETO15D-andresmape1991@gmail.com', 'PURCHASE_COMPLETE', 'Fayber Mape', 'andresmape1991@gmail.com', '573228539992', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-25T07:36:20'),
  ('RETO15D-ovalle.vanessa@gmail.com', 'PURCHASE_COMPLETE', 'Vanessa Ovalle', 'ovalle.vanessa@gmail.com', '16309011444', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-25T10:11:47'),
  ('RETO15D-clauloc@outlook.com', 'PURCHASE_COMPLETE', 'Claudia Lopez', 'clauloc@outlook.com', '525622165389', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-04-25T11:27:29'),
  ('RETO15D-gokuygohan9999@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Giraldo', 'gokuygohan9999@gmail.com', '573017871563', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-25T12:09:04'),
  ('RETO15D-memero86@gmail.com', 'PURCHASE_COMPLETE', 'Alberto Altamirano', 'memero86@gmail.com', '593998040473', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-25T12:39:04'),
  ('RETO15D-luis.feernandog@gmail.com', 'PURCHASE_COMPLETE', 'Luis Fernando Guanga Benavides', 'luis.feernandog@gmail.com', '573177001139', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-25T15:08:26'),
  ('RETO15D-angelikbp45@gmail.com', 'PURCHASE_COMPLETE', 'Angelica Ballesteros', 'angelikbp45@gmail.com', '573204780251', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-25T15:38:00'),
  ('RETO15D-claudiaaserna@hotmail.com', 'PURCHASE_COMPLETE', 'Claudia Veronica Mendivil Serna', 'claudiaaserna@hotmail.com', '526871169236', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-25T16:31:26'),
  ('RETO15D-contactomagentaxv@gmail.com', 'PURCHASE_COMPLETE', 'Viridiana Andrés Jiménez', 'contactomagentaxv@gmail.com', '529511167805', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-25T16:43:52'),
  ('RETO15D-mkarmengl@hotmail.com', 'PURCHASE_COMPLETE', 'Marycarmen Gutiérrez López', 'mkarmengl@hotmail.com', '522221836002', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-25T21:49:26'),
  ('RETO15D-cindysilvajesus8@gmail.com', 'PURCHASE_COMPLETE', 'Cindy Silva', 'cindysilvajesus8@gmail.com', '12096290560', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-26T00:20:43'),
  ('RETO15D-carlosbuitrago1992@hotmail.com', 'PURCHASE_COMPLETE', 'Carlos Buitrago', 'carlosbuitrago1992@hotmail.com', '573044817003', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-26T00:25:14'),
  ('RETO15D-kaorimurasaki205@gmail.com', 'PURCHASE_COMPLETE', 'Kaori Murasaki', 'kaorimurasaki205@gmail.com', '525574950097', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-04-26T00:31:59'),
  ('RETO15D-edwar31mejia@gmail.com', 'PURCHASE_COMPLETE', 'Edwar alexander mejia cano', 'edwar31mejia@gmail.com', '573164584700', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-26T08:06:04'),
  ('RETO15D-lejarazu86@gmail.com', 'PURCHASE_COMPLETE', 'Maricarmen Lejarazu', 'lejarazu86@gmail.com', '56935614810', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-26T08:49:03'),
  ('RETO15D-maymont6212@gmail.com', 'PURCHASE_COMPLETE', 'Mayra Velázquez', 'maymont6212@gmail.com', '525566128895', 'MX', 'Reto 15D', 37.02, 'USD', 'active', '2025-04-26T18:25:04'),
  ('RETO15D-gifagomu1986@gmail.com', 'PURCHASE_COMPLETE', 'Gina Farley Godoy Murillo', 'gifagomu1986@gmail.com', '573206429839', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-26T22:03:19'),
  ('RETO15D-johamarketing@gmail.com', 'PURCHASE_COMPLETE', 'Joha Enciso Gutiérrez', 'johamarketing@gmail.com', '17864796101', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-26T22:47:27'),
  ('RETO15D-cohencaceres@gmail.com', 'PURCHASE_COMPLETE', 'Maria Concepcion Gaona', 'cohencaceres@gmail.com', '5950981445146', 'PY', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-27T06:23:21'),
  ('RETO15D-lanishellw@hotmail.com', 'PURCHASE_COMPLETE', 'Lanishell Wong', 'lanishellw@hotmail.com', '573208590532', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-27T09:11:56'),
  ('RETO15D-narusanarusewawa@gmail.com', 'PURCHASE_COMPLETE', 'Diana Verenice Cervantes Garcia', 'narusanarusewawa@gmail.com', '523141065544', 'MX', 'Reto 15D', 37.02, 'USD', 'active', '2025-04-27T10:37:22'),
  ('RETO15D-marisolenriquez0101@gmail.com', 'PURCHASE_COMPLETE', 'Marisol Enriquez', 'marisolenriquez0101@gmail.com', '12255730942', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-27T11:55:45'),
  ('RETO15D-carlosballesteros777@hotmail.com', 'PURCHASE_COMPLETE', 'Carlos ballesteros', 'carlosballesteros777@hotmail.com', '573145807529', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-27T13:20:09'),
  ('RETO15D-cris_david97@hotmail.com', 'PURCHASE_COMPLETE', 'Cristopher Muzzio', 'cris_david97@hotmail.com', '5930981291917', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-27T17:08:45'),
  ('RETO15D-creativo@erickraw.page', 'PURCHASE_COMPLETE', 'Erick torres', 'creativo@erickraw.page', '573054150129', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-27T18:54:45'),
  ('RETO15D-dianajarangoa@gmail.com', 'PURCHASE_COMPLETE', 'Diana Jaramillo A', 'dianajarangoa@gmail.com', '17866220677', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-27T21:34:56'),
  ('RETO15D-pilar.sanchez1919@gmail.com', 'PURCHASE_COMPLETE', 'Pilar Sanchez', 'pilar.sanchez1919@gmail.com', '573145616151', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-28T07:01:01'),
  ('RETO15D-alfredodelcastillo511@gmail.com', 'PURCHASE_COMPLETE', 'Alfredo del Castillo', 'alfredodelcastillo511@gmail.com', '19296089388', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-28T16:05:26'),
  ('RETO15D-rodrigoospino@hotmail.com', 'PURCHASE_COMPLETE', 'Rodrigo ospino', 'rodrigoospino@hotmail.com', '573016658288', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-28T16:16:59'),
  ('RETO15D-tatianavargas026@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Vargas', 'tatianavargas026@gmail.com', '573202653982', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-28T22:02:02'),
  ('RETO15D-mercadeoglobalvitality@gmail.com', 'PURCHASE_COMPLETE', 'Diego Restrepo', 'mercadeoglobalvitality@gmail.com', '573178549895', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-29T09:25:43'),
  ('RETO15D-vibesbgta@gmail.com', 'PURCHASE_COMPLETE', 'Cristian Ladino Ojeda', 'vibesbgta@gmail.com', '573204155733', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-29T17:46:31'),
  ('RETO15D-maikolquintero20@gmail.com', 'PURCHASE_COMPLETE', 'Steven Quintero', 'maikolquintero20@gmail.com', '573006421199', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-29T18:02:25'),
  ('RETO15D-toutsurlemarketingdereseau@gmail.com', 'PURCHASE_COMPLETE', 'Mathieu Remi', 'toutsurlemarketingdereseau@gmail.com', '525566568324', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-04-29T20:48:13'),
  ('RETO15D-lauravierab@gmail.com', 'PURCHASE_COMPLETE', 'laura viera', 'lauravierab@gmail.com', '573147453046', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-29T22:45:23'),
  ('RETO15D-erickarnulfo2@gmail.com', 'PURCHASE_COMPLETE', 'Heriberto Arnulfo jose', 'erickarnulfo2@gmail.com', '529982443235', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-04-30T02:23:06'),
  ('RETO15D-lisandrapi1986@gmail.com', 'PURCHASE_COMPLETE', 'Lisandra Pi Fuentes', 'lisandrapi1986@gmail.com', '117864736025', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-30T07:33:02'),
  ('RETO15D-ovejares@gmail.com', 'PURCHASE_COMPLETE', 'Oscar vejares olivera', 'ovejares@gmail.com', '56961407453', 'CL', 'Reto 15D', 36.92, 'USD', 'active', '2025-04-30T11:12:47'),
  ('RETO15D-infodosantosfc@gmail.com', 'PURCHASE_COMPLETE', 'Diego Hernan Murillo', 'infodosantosfc@gmail.com', '573173905562', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-30T13:04:16'),
  ('RETO15D-edgar.garcia.rsvp@gmail.com', 'PURCHASE_COMPLETE', 'Edgar García', 'edgar.garcia.rsvp@gmail.com', '529983072394', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-04-30T13:36:48'),
  ('RETO15D-rlopezp.ambassador@gmail.com', 'PURCHASE_COMPLETE', 'Vanessa lopez', 'rlopezp.ambassador@gmail.com', '51944162109', 'PE', 'Reto 15D', 37.37, 'USD', 'active', '2025-04-30T14:38:53'),
  ('RETO15D-maitevega758@gmail.com', 'PURCHASE_COMPLETE', 'Pamela Bobadilla', 'maitevega758@gmail.com', '112406394115', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-30T15:20:11'),
  ('RETO15D-palomacm@me.com', 'PURCHASE_COMPLETE', 'Paloma Castillo', 'palomacm@me.com', '525529001657', 'MX', 'Reto 15D', 36.95, 'USD', 'active', '2025-04-30T18:30:59'),
  ('RETO15D-yeimybm@hotmail.com', 'PURCHASE_COMPLETE', 'Yeimy botero', 'yeimybm@hotmail.com', '573116262560', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-30T18:33:08'),
  ('RETO15D-glenda.carranza@gmail.com', 'PURCHASE_COMPLETE', 'Glenda Carranza Rodriguez', 'glenda.carranza@gmail.com', '525516457665', 'MX', 'Reto 15D', 36.95, 'USD', 'active', '2025-04-30T21:09:14'),
  ('RETO15D-romor.oficial@gmail.com', 'PURCHASE_COMPLETE', 'Patricio Jesús Román Morgado', 'romor.oficial@gmail.com', '56975845508', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-30T21:54:46'),
  ('RETO15D-jennyvivianamartinez1987@gmail.com', 'PURCHASE_COMPLETE', 'Jenny viviana', 'jennyvivianamartinez1987@gmail.com', '56949721052', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-04-30T23:18:42'),
  ('RETO15D-aguilerabrito.beatriz@gmail.com', 'PURCHASE_COMPLETE', 'Beatriz Aguilera', 'aguilerabrito.beatriz@gmail.com', '56994252429', 'CL', 'Reto 15D', 35.00, 'USD', 'active', '2025-04-30T23:18:34'),
  ('RETO15D-alexipatino78@gmail.com', 'PURCHASE_COMPLETE', 'Alexis Patiño', 'alexipatino78@gmail.com', '573023716959', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T07:54:52'),
  ('RETO15D-lozpatricia@gmail.com', 'PURCHASE_COMPLETE', 'Patricia Lozano', 'lozpatricia@gmail.com', '573104041994', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T08:14:30'),
  ('RETO15D-bitacoraroundtrip@gmail.com', 'PURCHASE_COMPLETE', 'Aleimar Rodriguez', 'bitacoraroundtrip@gmail.com', '18328357169', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-01T09:45:46'),
  ('RETO15D-manuelavilla06@hotmail.com', 'PURCHASE_COMPLETE', 'Manuela Villa', 'manuelavilla06@hotmail.com', '573207284706', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T09:46:58'),
  ('RETO15D-delvinquispem@gmail.com', 'PURCHASE_COMPLETE', 'Delvin Quispe', 'delvinquispem@gmail.com', '51978391622', 'PE', 'Reto 15D', 37.37, 'USD', 'active', '2025-05-01T12:04:38'),
  ('RETO15D-eligilram@gmail.com', 'PURCHASE_COMPLETE', 'Elizabeth Gil Ramirez', 'eligilram@gmail.com', '573004869467', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T15:35:40'),
  ('RETO15D-lic.victorjavier@hotmail.com', 'PURCHASE_COMPLETE', 'Victor javier Sanchez', 'lic.victorjavier@hotmail.com', '527226009153', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T17:43:41'),
  ('RETO15D-rocio.astocaza@gmail.com', 'PURCHASE_COMPLETE', 'Rocio Astocaza Flores', 'rocio.astocaza@gmail.com', '51962332779', 'PE', 'Reto 15D', 37.25, 'USD', 'active', '2025-05-01T19:27:46'),
  ('RETO15D-saligore@hotmail.com', 'PURCHASE_COMPLETE', 'Sandra Liliana Gonzalez Rendon', 'saligore@hotmail.com', '16892697357', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T21:39:42'),
  ('RETO15D-rickdelarosa@outlook.com', 'PURCHASE_COMPLETE', 'Rick de la R', 'rickdelarosa@outlook.com', '525525617996', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-01T23:19:44'),
  ('RETO15D-rivera172050@gmail.com', 'PURCHASE_COMPLETE', 'Constantino Rivera Acevedo', 'rivera172050@gmail.com', '51981347056', 'PE', 'Reto 15D', 37.25, 'USD', 'active', '2025-05-02T01:20:48'),
  ('RETO15D-leidyquicenoc@gmail.com', 'PURCHASE_COMPLETE', 'Leidy Quiceno', 'leidyquicenoc@gmail.com', '573178099599', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T06:18:05'),
  ('RETO15D-manuelyongb@hotmail.com', 'PURCHASE_COMPLETE', 'Manuel Yong Betancourt', 'manuelyongb@hotmail.com', '524421494414', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T06:57:50'),
  ('RETO15D-depositosonline24@gmail.com', 'PURCHASE_COMPLETE', 'Jesus Segura', 'depositosonline24@gmail.com', '13237936257', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-02T07:38:24'),
  ('RETO15D-pariasrealtor@gmail.com', 'PURCHASE_COMPLETE', 'Paula arias', 'pariasrealtor@gmail.com', '573108136313', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T08:36:54'),
  ('RETO15D-stellakin69@gmail.com', 'PURCHASE_COMPLETE', 'Stella Gomez', 'stellakin69@gmail.com', '573054606549', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T11:11:48'),
  ('RETO15D-charlesbarrera@hotmail.es', 'PURCHASE_COMPLETE', 'Charles Andres Barrera Giraldo', 'charlesbarrera@hotmail.es', '573013387080', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T12:56:55'),
  ('RETO15D-edwinrodriguezm777@gmail.com', 'PURCHASE_COMPLETE', 'Edwin Rodríguez', 'edwinrodriguezm777@gmail.com', '573153712295', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T16:35:03'),
  ('RETO15D-marlloryvd94@outlook.com', 'PURCHASE_COMPLETE', 'Marllory Carolina Venegas Domínguez', 'marlloryvd94@outlook.com', '593962576922', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-02T17:18:03'),
  ('RETO15D-bellocabreran@gmail.com', 'PURCHASE_COMPLETE', 'Naomi Bello', 'bellocabreran@gmail.com', '17868260811', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-02T18:42:54'),
  ('RETO15D-julianlandazabal01@gmail.com', 'PURCHASE_COMPLETE', 'Gerson Julián  Landazabal Rodríguez', 'julianlandazabal01@gmail.com', '573208335325', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-02T21:41:26'),
  ('RETO15D-diazconsultorescontables@gmail.com', 'PURCHASE_COMPLETE', 'Victoria Díaz', 'diazconsultorescontables@gmail.com', '593999921259', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-02T22:53:29'),
  ('RETO15D-daisymacmontoyav@gmail.com', 'PURCHASE_COMPLETE', 'Daisy Montoya Valencia', 'daisymacmontoyav@gmail.com', '573127395632', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T06:01:40'),
  ('RETO15D-leowave97@hotmail.com', 'PURCHASE_COMPLETE', 'Leonel Ledesma', 'leowave97@hotmail.com', '543884137484', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-05-03T06:44:36'),
  ('RETO15D-castrorubiela1982@gmail.com', 'PURCHASE_COMPLETE', 'Rubiela Castro', 'castrorubiela1982@gmail.com', '573202633045', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T07:09:12'),
  ('RETO15D-yeapare@gmail.com', 'PURCHASE_COMPLETE', 'YEFFER ARLEY PARRA RENTERIA', 'yeapare@gmail.com', '573104121454', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T10:20:47'),
  ('RETO15D-silviagonzalez.mkt@gmail.com', 'PURCHASE_COMPLETE', 'Silvia González', 'silviagonzalez.mkt@gmail.com', '528332884860', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-05-03T10:37:03'),
  ('RETO15D-rosendobig2016@gmail.com', 'PURCHASE_COMPLETE', 'Rosendo Argote', 'rosendobig2016@gmail.com', '573024715674', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T13:32:47'),
  ('RETO15D-engyyes@hotmail.com', 'PURCHASE_COMPLETE', 'Engie Ramirez', 'engyyes@hotmail.com', '573203200298', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T14:57:20'),
  ('RETO15D-javibillions@gmail.com', 'PURCHASE_COMPLETE', 'Juan Serrano', 'javibillions@gmail.com', '12393834419', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-03T15:20:07'),
  ('RETO15D-nataorma.30@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Ortiz', 'nataorma.30@gmail.com', '573135943411', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T16:01:24'),
  ('RETO15D-dmarcemont@hotmail.com', 'PURCHASE_COMPLETE', 'Marcela Montenegro Robayo', 'dmarcemont@hotmail.com', '573144341359', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T17:53:20'),
  ('RETO15D-daniycn13@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Castillo', 'daniycn13@gmail.com', '573246640429', 'PE', 'Reto 15D', 37.28, 'USD', 'active', '2025-05-03T22:00:10'),
  ('RETO15D-alexpuentess10@gmail.com', 'PURCHASE_COMPLETE', 'Alex Puentes', 'alexpuentess10@gmail.com', '56974807532', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-03T22:00:14'),
  ('RETO15D-albeiroosorio182@gmail.com', 'PURCHASE_COMPLETE', 'Albeiro Osorio Restrepo', 'albeiroosorio182@gmail.com', '573177678684', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-03T22:33:12'),
  ('RETO15D-luismotacreativo@gmail.com', 'PURCHASE_COMPLETE', 'Luis Fernando Mota', 'luismotacreativo@gmail.com', '15154212187', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-03T23:56:09'),
  ('RETO15D-jesika.giraldo@gmail.com', 'PURCHASE_COMPLETE', 'Jessica giraldo', 'jesika.giraldo@gmail.com', '573233725511', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T05:25:59'),
  ('RETO15D-eriyul21@hotmail.com', 'PURCHASE_COMPLETE', 'Erika Ordoñez', 'eriyul21@hotmail.com', '573158975250', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T06:05:17'),
  ('RETO15D-yimarire_03@hotmail.com', 'PURCHASE_COMPLETE', 'yina marcela rios', 'yimarire_03@hotmail.com', '573502672233', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T09:51:55'),
  ('RETO15D-estebanbedoya07@gmail.com', 'PURCHASE_COMPLETE', 'Esteban Bedoya', 'estebanbedoya07@gmail.com', '573176546140', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T12:17:28'),
  ('RETO15D-mariacamiladuque626@hotmail.com', 'PURCHASE_COMPLETE', 'Maria camila duque', 'mariacamiladuque626@hotmail.com', '573185275662', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T12:17:53'),
  ('RETO15D-glenisyc1985@gmail.com', 'PURCHASE_COMPLETE', 'Glenis Camacho', 'glenisyc1985@gmail.com', '573175442828', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T19:24:05'),
  ('RETO15D-gustavoadolfof@yahoo.com', 'PURCHASE_COMPLETE', 'Gustavo Adolfo Fonseca S.', 'gustavoadolfof@yahoo.com', '573197066746', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T20:14:34'),
  ('RETO15D-moni.mateus@hotmail.com', 'PURCHASE_COMPLETE', 'Mónica Mateus Martinez', 'moni.mateus@hotmail.com', '573112868672', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-04T21:06:45'),
  ('RETO15D-arlynxm3@gmail.com', 'PURCHASE_COMPLETE', 'Arlyn Mendoza', 'arlynxm3@gmail.com', '19096315768', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-04T22:22:46'),
  ('RETO15D-varolas@hotmail.com', 'PURCHASE_COMPLETE', 'Alvaro Estrada', 'varolas@hotmail.com', '523111081919', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-05T01:02:06'),
  ('RETO15D-elianats101995@hotmail.com', 'PURCHASE_COMPLETE', 'Eliana Andrea Torres Sierra', 'elianats101995@hotmail.com', '573214656862', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-05T01:06:12'),
  ('RETO15D-andrepadilla_dg@hotmail.es', 'PURCHASE_COMPLETE', 'Andrea Padilla Borja', 'andrepadilla_dg@hotmail.es', '573045603077', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-05T10:12:51'),
  ('RETO15D-digitizeteam@gmail.com', 'PURCHASE_COMPLETE', 'NEIBA CORDERO', 'digitizeteam@gmail.com', '18644511387', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-05T10:30:25'),
  ('RETO15D-jimmyferlissi@gmail.com', 'PURCHASE_COMPLETE', 'Jimmy ferlissi', 'jimmyferlissi@gmail.com', '56963437657', 'CL', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-05T17:04:45'),
  ('RETO15D-chenegrocr@gmail.com', 'PURCHASE_COMPLETE', 'Rebeca Ramirez', 'chenegrocr@gmail.com', '50670248602', 'CR', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-05T20:45:46'),
  ('RETO15D-letsanva@yahoo.com.mx', 'PURCHASE_COMPLETE', 'LETICIA SANCHEZ VAZQUEZ', 'letsanva@yahoo.com.mx', '524433364723', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-05-05T22:38:17'),
  ('RETO15D-voittogroup.az@gmail.com', 'PURCHASE_COMPLETE', 'Jesus gonzalez', 'voittogroup.az@gmail.com', '114805275973', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-05T23:56:51'),
  ('RETO15D-josmanleon2023@gmail.com', 'PURCHASE_COMPLETE', 'Josman Leon', 'josmanleon2023@gmail.com', '14259700488', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-06T03:03:10'),
  ('RETO15D-karolinatrochez@gmail.com', 'PURCHASE_COMPLETE', 'Caro Trochez', 'karolinatrochez@gmail.com', '18045733224', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-06T05:53:23'),
  ('RETO15D-andreapinzonq@gmail.com', 'PURCHASE_COMPLETE', 'Andrea Pinzon', 'andreapinzonq@gmail.com', '573107812320', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-06T06:43:35'),
  ('RETO15D-l.ortizcarvacho@gmail.com', 'PURCHASE_COMPLETE', 'Luis Ortiz', 'l.ortizcarvacho@gmail.com', '56940580380', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-06T07:08:49'),
  ('RETO15D-edgar5_14@hotmail.com', 'PURCHASE_COMPLETE', 'Edgar Quispe Arapa', 'edgar5_14@hotmail.com', '51930917645', 'PE', 'Reto 15D', 37.41, 'USD', 'active', '2025-05-06T07:51:42'),
  ('RETO15D-dannysase123@gmail.com', 'PURCHASE_COMPLETE', 'Danny Saavedra', 'dannysase123@gmail.com', '51973441385', 'PE', 'Reto 15D', 37.41, 'USD', 'active', '2025-05-06T08:44:42'),
  ('RETO15D-soyemilyarvi@gmail.com', 'PURCHASE_COMPLETE', 'Emilia ariza', 'soyemilyarvi@gmail.com', '573114015232', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-06T10:11:15'),
  ('RETO15D-kurtgajardo@gmail.com', 'PURCHASE_COMPLETE', 'Kurt Gajardo Morris', 'kurtgajardo@gmail.com', '56934058448', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-06T15:35:53'),
  ('RETO15D-diegoriascos16@gmail.com', 'PURCHASE_COMPLETE', 'Diego Fernando Riascos Pino', 'diegoriascos16@gmail.com', '573116047812', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-07T06:14:43'),
  ('RETO15D-creamosvalor1@gmail.com', 'PURCHASE_COMPLETE', 'Johanna Ramirez Castro', 'creamosvalor1@gmail.com', '573185747364', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-07T08:52:54'),
  ('RETO15D-hidelacruz@yahoo.com', 'PURCHASE_COMPLETE', 'Hilcia Macias', 'hidelacruz@yahoo.com', '17862660444', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-07T11:50:53'),
  ('RETO15D-imperiostours@gmail.com', 'PURCHASE_COMPLETE', 'Hector Fabio Sanchez', 'imperiostours@gmail.com', '573007525024', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-07T16:45:39'),
  ('RETO15D-geekjfredo@gmail.com', 'PURCHASE_COMPLETE', 'jhon fredy castaño', 'geekjfredo@gmail.com', '573128819198', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-07T17:01:00'),
  ('RETO15D-andreavelascofuxion@gmail.com', 'PURCHASE_COMPLETE', 'ANDREA VELASCO RIOS', 'andreavelascofuxion@gmail.com', '573216638373', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-07T18:51:06'),
  ('RETO15D-soylauhuerfano@gmail.com', 'PURCHASE_COMPLETE', 'Laura Carolina Huerfano Calderon', 'soylauhuerfano@gmail.com', '573213032147', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-07T19:03:46'),
  ('RETO15D-mcsaleos@gmail.com', 'PURCHASE_COMPLETE', 'Mayra Leos', 'mcsaleos@gmail.com', '19094529024', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-07T22:51:48'),
  ('RETO15D-geral99jll@gmail.com', 'PURCHASE_COMPLETE', 'Geraldine Juarez', 'geral99jll@gmail.com', '51926703196', 'PE', 'Reto 15D', 36.94, 'USD', 'active', '2025-05-07T23:41:20'),
  ('RETO15D-gonzalez_o_alejandro@hotmail.com', 'PURCHASE_COMPLETE', 'Michael Alejandro Gonzalez', 'gonzalez_o_alejandro@hotmail.com', '573137593849', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T03:38:17'),
  ('RETO15D-lauralorena99v@gmail.com', 'PURCHASE_COMPLETE', 'Laura Lorena Romero Viafara', 'lauralorena99v@gmail.com', '573118943869', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T07:45:59'),
  ('RETO15D-isabelpesantez.a@gmail.com', 'PURCHASE_COMPLETE', 'Isabel Pesántez', 'isabelpesantez.a@gmail.com', '5930987255282', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-08T10:35:41'),
  ('RETO15D-sosa-roa@hotmail.com', 'PURCHASE_COMPLETE', 'Mabel Jaramillo Sosa', 'sosa-roa@hotmail.com', '573188711588', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-08T12:48:23'),
  ('RETO15D-danipiercing.22@gmail.com', 'PURCHASE_COMPLETE', 'Sirley Romero', 'danipiercing.22@gmail.com', '573005358204', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T12:46:28'),
  ('RETO15D-elsybarrero@gmail.com', 'PURCHASE_COMPLETE', 'Elsy Ruth Barrero V', 'elsybarrero@gmail.com', '573178833320', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-08T13:39:49'),
  ('RETO15D-ginistoro1@gmail.com', 'PURCHASE_COMPLETE', 'Marcela Toro', 'ginistoro1@gmail.com', '573114237246', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-08T14:07:24'),
  ('RETO15D-diego.palacio10@hotmail.com', 'PURCHASE_COMPLETE', 'Diego palacio', 'diego.palacio10@hotmail.com', '573103970289', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T15:00:02'),
  ('RETO15D-luispo14@hotmail.com', 'PURCHASE_COMPLETE', 'Jorge Parra', 'luispo14@hotmail.com', '573206648136', 'CO', 'Reto 15D', 36.56, 'USD', 'active', '2025-05-08T15:40:21'),
  ('RETO15D-paola3qui@icloud.com', 'PURCHASE_COMPLETE', 'Paola Quiceno', 'paola3qui@icloud.com', '17328674779', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-08T18:26:40'),
  ('RETO15D-manu.rojas.rios@gmail.com', 'PURCHASE_COMPLETE', 'Manuela Rojas', 'manu.rojas.rios@gmail.com', '573122571393', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T18:59:16'),
  ('RETO15D-leidyjohana1003@hotmail.com', 'PURCHASE_COMPLETE', 'Leidy Garcia', 'leidyjohana1003@hotmail.com', '573142209670', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T19:19:25'),
  ('RETO15D-camilo-sanchez@hotmail.com', 'PURCHASE_COMPLETE', 'Camilo Sanchez Castaño', 'camilo-sanchez@hotmail.com', '573164782182', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T20:30:50'),
  ('RETO15D-lexmarketer2025@gmail.com', 'PURCHASE_COMPLETE', 'Angel iram Martinez Amaro', 'lexmarketer2025@gmail.com', '527227968678', 'MX', 'Reto 15D', 36.95, 'USD', 'active', '2025-05-08T22:09:48'),
  ('RETO15D-malun1694@hotmail.com', 'PURCHASE_COMPLETE', 'Marlon esnayder izquierdo alvarez', 'malun1694@hotmail.com', '573507538567', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T23:04:57'),
  ('RETO15D-davidduquecastillo@gmail.com', 'PURCHASE_COMPLETE', 'Cristhian David duque Castillo', 'davidduquecastillo@gmail.com', '573116123952', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-08T23:22:09'),
  ('RETO15D-jhonalexander2815@gmail.com', 'PURCHASE_COMPLETE', 'Jhon Alexander bocanegra Agudelo', 'jhonalexander2815@gmail.com', '573167487036', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-09T07:44:55'),
  ('RETO15D-alfonsoorozcoo@hotmail.com', 'PURCHASE_COMPLETE', 'Alfonso orozco', 'alfonsoorozcoo@hotmail.com', '529983853921', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-05-09T16:28:28'),
  ('RETO15D-joyasconexion.japamala@gmail.com', 'PURCHASE_COMPLETE', 'jessica alexandra bermudez', 'joyasconexion.japamala@gmail.com', '573193115044', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-09T19:45:03'),
  ('RETO15D-jpbravoa.jpb@gmail.com', 'PURCHASE_COMPLETE', 'Juan pablo Bravo', 'jpbravoa.jpb@gmail.com', '573145850785', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-09T21:27:44'),
  ('RETO15D-catalinach05@gmail.com', 'PURCHASE_COMPLETE', 'Catalina Chaguala Sanchez', 'catalinach05@gmail.com', '573128931738', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-10T15:07:37'),
  ('RETO15D-gallegosbruno96@gmail.com', 'PURCHASE_COMPLETE', 'Bruno Gallegos', 'gallegosbruno96@gmail.com', '5403513922230', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-05-10T20:48:16'),
  ('RETO15D-ramirez.salo08@gmail.com', 'PURCHASE_COMPLETE', 'SALOMON MORFIN', 'ramirez.salo08@gmail.com', '523411267703', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-05-11T14:28:45'),
  ('RETO15D-maryvit2601@gmail.com', 'PURCHASE_COMPLETE', 'María del Carmen Olivares Vite', 'maryvit2601@gmail.com', '524426070703', 'MX', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-11T23:45:10'),
  ('RETO15D-madretierranatural@hotmail.com', 'PURCHASE_COMPLETE', 'carolina robledo', 'madretierranatural@hotmail.com', '5713167598266', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-12T07:23:52'),
  ('RETO15D-rosabelrinconhernandez@gmail.com', 'PURCHASE_COMPLETE', 'Rosabel Rincon Hernandez', 'rosabelrinconhernandez@gmail.com', '573172581454', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-12T09:57:34'),
  ('RETO15D-soygusmasterdigital@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Lopez', 'soygusmasterdigital@gmail.com', '573123266967', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-13T08:00:10'),
  ('RETO15D-avanta.col@gmail.com', 'PURCHASE_COMPLETE', 'Miguel muñoz', 'avanta.col@gmail.com', '573126029038', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-13T10:57:08'),
  ('RETO15D-celso@clickdesignmedia.com', 'PURCHASE_COMPLETE', 'Celso Azamar', 'celso@clickdesignmedia.com', '114432213397', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-14T04:55:16'),
  ('RETO15D-vasquezgomezjenifer@gmail.com', 'PURCHASE_COMPLETE', 'Jenifer Vasquez', 'vasquezgomezjenifer@gmail.com', '573194626984', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-14T06:05:45'),
  ('RETO15D-soporteyeimerrestrepo@gmail.com', 'PURCHASE_COMPLETE', 'Yeimer Restrepo', 'soporteyeimerrestrepo@gmail.com', '573009536709', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-14T09:19:41'),
  ('RETO15D-dayro.bohorquez@gmail.com', 'PURCHASE_COMPLETE', 'Dayro Humberto Bohórquez Escobar', 'dayro.bohorquez@gmail.com', '573145907636', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-05-14T11:18:10'),
  ('RETO15D-jmbecerrar@icloud.com', 'PURCHASE_COMPLETE', 'José Manuel Becerra Romero', 'jmbecerrar@icloud.com', '573243687395', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-15T11:24:38'),
  ('RETO15D-danielapsepulveda@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Pino Sepúlveda', 'danielapsepulveda@gmail.com', '573106895845', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-15T11:29:37'),
  ('RETO15D-infrarojoestudio@gmail.com', 'PURCHASE_COMPLETE', 'Deyvid Montoya', 'infrarojoestudio@gmail.com', '573233828493', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-15T11:50:23'),
  ('RETO15D-durdely@gmail.com', 'PURCHASE_COMPLETE', 'Durdely Ramirez', 'durdely@gmail.com', '573005770799', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-15T13:12:12'),
  ('RETO15D-svascoca@gmail.com', 'PURCHASE_COMPLETE', 'Sara Vasco Cadavid', 'svascoca@gmail.com', '573013925467', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-15T15:06:02'),
  ('RETO15D-smosqueramazud@gmail.com', 'PURCHASE_COMPLETE', 'Sebastian mosquera', 'smosqueramazud@gmail.com', '573184705945', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-15T18:29:02'),
  ('RETO15D-prolims_eat1123@hotmail.com', 'PURCHASE_COMPLETE', 'Erick Añasco', 'prolims_eat1123@hotmail.com', '5930998133567', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-15T18:39:53'),
  ('RETO15D-valeriavalencia9635@gmail.com', 'PURCHASE_COMPLETE', 'Valeria Valencia Muñoz', 'valeriavalencia9635@gmail.com', '573122342119', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-16T11:46:52'),
  ('RETO15D-jhonathanjimenezg@gmail.com', 'PURCHASE_COMPLETE', 'Jhonatan Jiménez', 'jhonathanjimenezg@gmail.com', '573226545283', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-16T14:56:43'),
  ('RETO15D-ricardocardonaafiliado@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo Cardona', 'ricardocardonaafiliado@gmail.com', '50258944241', 'GT', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-16T16:21:40'),
  ('RETO15D-pauendec@gmail.com', 'PURCHASE_COMPLETE', 'Paulina Enderica', 'pauendec@gmail.com', '5930986934950', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-17T06:20:53'),
  ('RETO15D-angelita1985caicedo@hotmail.com', 'PURCHASE_COMPLETE', 'Bernardo caicedo', 'angelita1985caicedo@hotmail.com', '573157804396', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-17T08:43:03'),
  ('RETO15D-daymara.aroon.28@gmail.com', 'PURCHASE_COMPLETE', 'Daymara Rivas', 'daymara.aroon.28@gmail.com', '573057729653', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-17T09:11:42'),
  ('RETO15D-carocboteroo@gmail.com', 'PURCHASE_COMPLETE', 'Carolina C', 'carocboteroo@gmail.com', '56963901813', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-17T17:12:53'),
  ('RETO15D-carlospty7@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Santamaria', 'carlospty7@gmail.com', '50766181309', 'PA', 'Reto 15D', 38.87, 'USD', 'active', '2025-05-17T20:13:49'),
  ('RETO15D-edilmadeb@hotmail.com', 'PURCHASE_COMPLETE', 'Edilma de Barrera', 'edilmadeb@hotmail.com', '50763046899', 'PA', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-17T22:14:52'),
  ('RETO15D-jdelcastillo18@gmail.com', 'PURCHASE_COMPLETE', 'Tienda Galeras', 'jdelcastillo18@gmail.com', '573154955007', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-17T23:54:06'),
  ('RETO15D-trainer@paolapaico.com', 'PURCHASE_COMPLETE', 'Paola Paico', 'trainer@paolapaico.com', '51995120965', 'PE', 'Reto 15D', 37.04, 'USD', 'active', '2025-05-18T10:51:38'),
  ('RETO15D-ngallegolondono@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Gallego', 'ngallegolondono@gmail.com', '573175746544', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-18T10:52:09'),
  ('RETO15D-sbaquero555@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Nieto', 'sbaquero555@gmail.com', '16465225724', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-18T20:52:56'),
  ('RETO15D-alda.perez37@hotmail.com', 'PURCHASE_COMPLETE', 'Aldair Perez Ayala', 'alda.perez37@hotmail.com', '51987088359', 'PE', 'Reto 15D', 37.04, 'USD', 'active', '2025-05-18T21:43:04'),
  ('RETO15D-emprendo.mkt90@gmail.com', 'PURCHASE_COMPLETE', 'Catherine Díaz', 'emprendo.mkt90@gmail.com', '51912807883', 'PE', 'Reto 15D', 37.04, 'USD', 'active', '2025-05-19T00:01:08'),
  ('RETO15D-brandonsocampo@gmail.com', 'PURCHASE_COMPLETE', 'Brandon Ocampo', 'brandonsocampo@gmail.com', '573143542732', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-19T02:27:40'),
  ('RETO15D-hans@robles.com.ec', 'PURCHASE_COMPLETE', 'Hans Robles García', 'hans@robles.com.ec', '593994915347', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-19T06:48:23'),
  ('RETO15D-edgar7mauro@hotmail.com', 'PURCHASE_COMPLETE', 'Edgar guerra', 'edgar7mauro@hotmail.com', '51975351552', 'PE', 'Reto 15D', 37.04, 'USD', 'active', '2025-05-19T07:35:06'),
  ('RETO15D-kleberhoy@outlook.com', 'PURCHASE_COMPLETE', 'kleber quelal', 'kleberhoy@outlook.com', '593958992282', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-19T11:27:37'),
  ('RETO15D-marianaherrera460@gmail.com', 'PURCHASE_COMPLETE', 'Mariana Herrera', 'marianaherrera460@gmail.com', '573197630186', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-19T12:10:33'),
  ('RETO15D-diegopg816@gmail.com', 'PURCHASE_COMPLETE', 'Diego Andres Patiño Galindo', 'diegopg816@gmail.com', '573108648879', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-19T16:30:30'),
  ('RETO15D-jhonyadelgadof@gmail.com', 'PURCHASE_COMPLETE', 'Jhony Delgado Florez', 'jhonyadelgadof@gmail.com', '573147885840', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-19T19:11:09'),
  ('RETO15D-rossinardzconsultoria@gmail.com', 'PURCHASE_COMPLETE', 'Rossina Rodriguez', 'rossinardzconsultoria@gmail.com', '528114134197', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-05-20T10:00:14'),
  ('RETO15D-luisamlopera@gmail.com', 'PURCHASE_COMPLETE', 'Luisa Lopera', 'luisamlopera@gmail.com', '573113788432', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-20T11:01:09'),
  ('RETO15D-juanyvillalbaendigital@gmail.com', 'PURCHASE_COMPLETE', 'Juany Villalba', 'juanyvillalbaendigital@gmail.com', '5950992603841', 'PY', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-20T11:33:06'),
  ('RETO15D-tatyspretty@hotmail.com', 'PURCHASE_COMPLETE', 'Tatiana Romero', 'tatyspretty@hotmail.com', '5930999717879', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-20T14:05:55'),
  ('RETO15D-ana.gomez@jeanscolombianos.com', 'PURCHASE_COMPLETE', 'Ana Maria Gomez', 'ana.gomez@jeanscolombianos.com', '573188270557', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-20T18:11:55'),
  ('RETO15D-valstudiocreative@gmail.com', 'PURCHASE_COMPLETE', 'Valeria rodas', 'valstudiocreative@gmail.com', '573014381707', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-20T19:10:50'),
  ('RETO15D-samuelboca.111@gmail.com', 'PURCHASE_COMPLETE', 'Samuel bocanumenth', 'samuelboca.111@gmail.com', '573154153312', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-20T20:07:30'),
  ('RETO15D-dianadelgadodigital@gmail.com', 'PURCHASE_COMPLETE', 'Diana Delgado', 'dianadelgadodigital@gmail.com', '573174273795', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-20T23:12:50'),
  ('RETO15D-raule0997@gmail.com', 'PURCHASE_COMPLETE', 'Raul Esteban Castaño Salazar', 'raule0997@gmail.com', '573217420378', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T06:40:31'),
  ('RETO15D-enriquevillalobosr@gmail.com', 'PURCHASE_COMPLETE', 'Enrique Villalobos Rodriguez', 'enriquevillalobosr@gmail.com', '523481025754', 'MX', 'Reto 15D', 36.95, 'USD', 'active', '2025-05-21T11:21:06'),
  ('RETO15D-pablostefanodg@gmail.com', 'PURCHASE_COMPLETE', 'PABLO DIAZ', 'pablostefanodg@gmail.com', '593989784440', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-21T14:01:37'),
  ('RETO15D-madelenyy21@gmail.com', 'PURCHASE_COMPLETE', 'Madeleny Mejia', 'madelenyy21@gmail.com', '573015079827', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T14:01:44'),
  ('RETO15D-diestros1@gmail.com', 'PURCHASE_COMPLETE', 'Alvaro Enrique Osorio García', 'diestros1@gmail.com', '573152901017', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T14:56:30'),
  ('RETO15D-linatamayo@remaxm.net', 'PURCHASE_COMPLETE', 'Lina Tamayo', 'linatamayo@remaxm.net', '18293414827', 'DO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T15:09:16'),
  ('RETO15D-esteban_jz@outlook.es', 'PURCHASE_COMPLETE', 'Esteban Jaramillo', 'esteban_jz@outlook.es', '573146775197', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T17:37:08'),
  ('RETO15D-gonzalezmlaura@hotmail.com', 'PURCHASE_COMPLETE', 'Laura Marina González', 'gonzalezmlaura@hotmail.com', '573217068699', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T19:20:22'),
  ('RETO15D-alejandra.frost.a@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra frost', 'alejandra.frost.a@gmail.com', '56981363227', 'CL', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-21T20:31:58'),
  ('RETO15D-gustavosorio1020@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Osorio', 'gustavosorio1020@gmail.com', '573046618072', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-21T21:23:51'),
  ('RETO15D-alexanderdomenech.b@gmail.com', 'PURCHASE_COMPLETE', 'Alex Dom', 'alexanderdomenech.b@gmail.com', '573102144322', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-22T01:06:57'),
  ('RETO15D-aizajar@gmail.com', 'PURCHASE_COMPLETE', 'Genesis Bracho', 'aizajar@gmail.com', '17544223859', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-22T05:32:24'),
  ('RETO15D-golgag@yahoo.com', 'PURCHASE_COMPLETE', 'Olga Gonzalez', 'golgag@yahoo.com', '573006125101', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-22T09:30:36'),
  ('RETO15D-ceciliaorellana27@gmail.com', 'PURCHASE_COMPLETE', 'Cecilia Orellana', 'ceciliaorellana27@gmail.com', '12018871744', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-22T11:21:14'),
  ('RETO15D-garpchile@gmail.com', 'PURCHASE_COMPLETE', 'Gabriela Rojas', 'garpchile@gmail.com', '56948012145', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-22T17:47:59'),
  ('RETO15D-jdjcoronado@yahoo.es', 'PURCHASE_COMPLETE', 'José de Jesus', 'jdjcoronado@yahoo.es', '573107391587', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-22T22:10:04'),
  ('RETO15D-sandrasantamariacoach@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Milena Santamaria', 'sandrasantamariacoach@gmail.com', '573154838176', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-23T07:01:37'),
  ('RETO15D-jucamilo15@hotmail.com', 'PURCHASE_COMPLETE', 'Juan Camilo Beltran Ayala', 'jucamilo15@hotmail.com', '115484680101', 'CA', 'Reto 15D', 37.52, 'USD', 'active', '2025-05-23T08:10:37'),
  ('RETO15D-karla8383carrillo@yahoo.com', 'PURCHASE_COMPLETE', 'Karla Carrillo', 'karla8383carrillo@yahoo.com', '114155745343', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-23T09:07:09'),
  ('RETO15D-marianelacardenasv@yahoo.es', 'PURCHASE_COMPLETE', 'Marianela Cárdenas', 'marianelacardenasv@yahoo.es', '573103096891', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-23T10:25:37'),
  ('RETO15D-bibikjeldsen@gmail.com', 'PURCHASE_COMPLETE', 'Viviana Kjeldsen', 'bibikjeldsen@gmail.com', '19149201737', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-23T11:17:43'),
  ('RETO15D-carloscamacho.doc@gmail.com', 'PURCHASE_COMPLETE', 'carlos camacho', 'carloscamacho.doc@gmail.com', '573153061993', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-23T17:48:28'),
  ('RETO15D-john.loaiza.guerra@gmail.com', 'PURCHASE_COMPLETE', 'John Loaiza', 'john.loaiza.guerra@gmail.com', '573052492697', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-23T21:12:14'),
  ('RETO15D-lianariosh@gmail.com', 'PURCHASE_COMPLETE', 'Liana Rios', 'lianariosh@gmail.com', '573176667951', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-23T23:12:55'),
  ('RETO15D-lusuarez.med@gmail.com', 'PURCHASE_COMPLETE', 'Luisa suarez', 'lusuarez.med@gmail.com', '573202142620', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-24T08:08:02'),
  ('RETO15D-yamilok-13@hotmail.com', 'PURCHASE_COMPLETE', 'Yamile Cortes', 'yamilok-13@hotmail.com', '573134482249', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-24T08:28:31'),
  ('RETO15D-jaimeuriasmkt@gmail.com', 'PURCHASE_COMPLETE', 'Jaime Urías', 'jaimeuriasmkt@gmail.com', '526721234844', 'MX', 'Reto 15D', 37.02, 'USD', 'active', '2025-05-24T14:55:41'),
  ('RETO15D-vanesa@mentalidadinquebrantable.com', 'PURCHASE_COMPLETE', 'Vanesa Fernández mejido', 'vanesa@mentalidadinquebrantable.com', '541154871413', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-05-24T15:12:49'),
  ('RETO15D-danielaom31.dom@gmail.com', 'PURCHASE_COMPLETE', 'Daniela Ospina Marulanda', 'danielaom31.dom@gmail.com', '573163709960', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-24T16:10:01'),
  ('RETO15D-cesargarcia72012@hotmail.com', 'PURCHASE_COMPLETE', 'CESAR AUGUSTO GARCIA PEREZ', 'cesargarcia72012@hotmail.com', '573041074633', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-24T18:06:27'),
  ('RETO15D-geovanylondono1@hotmail.com', 'PURCHASE_COMPLETE', 'Geovani Londoño', 'geovanylondono1@hotmail.com', '573173355650', 'CO', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-24T19:23:21'),
  ('RETO15D-vivienvacafashion@gmail.com', 'PURCHASE_COMPLETE', 'Vivien vaca', 'vivienvacafashion@gmail.com', '5930981174411', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-24T19:26:32'),
  ('RETO15D-enrique.isarra@gmail.com', 'PURCHASE_COMPLETE', 'Enrique Isarra', 'enrique.isarra@gmail.com', '51992191219', 'PE', 'Reto 15D', 36.96, 'USD', 'active', '2025-05-24T20:07:26'),
  ('RETO15D-crksoritor@gmail.com', 'PURCHASE_COMPLETE', 'Usiel Rojas', 'crksoritor@gmail.com', '51935101552', 'PE', 'Reto 15D', 36.96, 'USD', 'active', '2025-05-24T21:56:30'),
  ('RETO15D-arqous.info@gmail.com', 'PURCHASE_COMPLETE', 'Arqous Corp', 'arqous.info@gmail.com', '17868968246', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-24T22:58:01'),
  ('RETO15D-michaelcruzhomes@gmail.com', 'PURCHASE_COMPLETE', 'Michael Cruz', 'michaelcruzhomes@gmail.com', '14075307620', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-25T06:33:27'),
  ('RETO15D-mitchelckimberlyn@gmail.com', 'PURCHASE_COMPLETE', 'Mitchel cedeño', 'mitchelckimberlyn@gmail.com', '118542369012', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-25T07:49:42'),
  ('RETO15D-tlandetta@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana landeta', 'tlandetta@gmail.com', '593991775229', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-25T08:40:35'),
  ('RETO15D-norly.cabrera@riverdistrict14.com', 'PURCHASE_COMPLETE', 'NORLY CABRERA', 'norly.cabrera@riverdistrict14.com', '17863005012', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-25T11:46:06'),
  ('RETO15D-dentalclubcenter@gmail.com', 'PURCHASE_COMPLETE', 'Octavio Torrecilla', 'dentalclubcenter@gmail.com', '527226165686', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-05-25T12:14:53'),
  ('RETO15D-yosoymafe@gmail.com', 'PURCHASE_COMPLETE', 'Maria Torres', 'yosoymafe@gmail.com', '573153174601', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-25T15:57:55'),
  ('RETO15D-finanzasesumer@gmail.com', 'PURCHASE_COMPLETE', 'Alonso Zuluaga', 'finanzasesumer@gmail.com', '573174354962', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-25T16:17:49'),
  ('RETO15D-carlosdiego8@yahoo.com.co', 'PURCHASE_COMPLETE', 'Carlos ortiz', 'carlosdiego8@yahoo.com.co', '573117477926', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-25T21:06:28'),
  ('RETO15D-joseangelsantosgaitan@gmail.com', 'PURCHASE_COMPLETE', 'Jose Angel Santos Gaitan', 'joseangelsantosgaitan@gmail.com', '526647584416', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-05-25T21:58:30'),
  ('RETO15D-darias.sepulveda@gmail.com', 'PURCHASE_COMPLETE', 'David Arias Sepulveda', 'darias.sepulveda@gmail.com', '573207410312', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-25T23:23:26'),
  ('RETO15D-ncruz02@gmail.com', 'PURCHASE_COMPLETE', 'Norberto Cruz', 'ncruz02@gmail.com', '116026538100', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-25T23:45:54'),
  ('RETO15D-henryalbertocr@gmail.com', 'PURCHASE_COMPLETE', 'henry castañeda', 'henryalbertocr@gmail.com', '573242197179', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-26T00:42:09'),
  ('RETO15D-ljohanaosorio@gmail.com', 'PURCHASE_COMPLETE', 'Johana Osorio', 'ljohanaosorio@gmail.com', '18137862946', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-26T06:27:32'),
  ('RETO15D-lina.de.do@gmail.com', 'PURCHASE_COMPLETE', 'Lina Denis', 'lina.de.do@gmail.com', '522292070525', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-05-26T07:35:00'),
  ('RETO15D-info@amhpartnersllc.com', 'PURCHASE_COMPLETE', 'Alfrdo Montiel', 'info@amhpartnersllc.com', '118453812782', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-26T09:41:13'),
  ('RETO15D-mariapaula@qhubocars.com', 'PURCHASE_COMPLETE', 'Maria Quintero', 'mariapaula@qhubocars.com', '117867848933', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-26T10:36:06'),
  ('RETO15D-claraliagutierrez@gmail.com', 'PURCHASE_COMPLETE', 'Clara Lia Gutierrez', 'claraliagutierrez@gmail.com', '573218010677', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-26T11:25:03'),
  ('RETO15D-estevancartagena@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Esteban Martinez Cartagena', 'estevancartagena@gmail.com', '573172422348', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-26T13:15:57'),
  ('RETO15D-villanica@gmail.com', 'PURCHASE_COMPLETE', 'Veronica Arango', 'villanica@gmail.com', '573022064105', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-26T21:44:23'),
  ('RETO15D-liizlacruz@gmail.com', 'PURCHASE_COMPLETE', 'Liz Lacruz', 'liizlacruz@gmail.com', '573108084652', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-26T21:59:02'),
  ('RETO15D-bexterfilms1518@gmail.com', 'PURCHASE_COMPLETE', 'Dilan Alejandro Morales Vélez', 'bexterfilms1518@gmail.com', '593979127607', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-27T00:44:40'),
  ('RETO15D-rebecademonzon@yahoo.com.mx', 'PURCHASE_COMPLETE', 'Rebeca Polá de Monzón', 'rebecademonzon@yahoo.com.mx', '50237580111', 'GT', 'Reto 15D', 37.01, 'USD', 'active', '2025-05-27T07:06:02'),
  ('RETO15D-klaudyaportes@gmail.com', 'PURCHASE_COMPLETE', 'Claudia romero', 'klaudyaportes@gmail.com', '114709096892', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-27T08:30:44'),
  ('RETO15D-zullihoyod@gmail.com', 'PURCHASE_COMPLETE', 'Zully Hoyos', 'zullihoyod@gmail.com', '573150525897', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-27T08:43:45'),
  ('RETO15D-molinafabianarq@gmail.com', 'PURCHASE_COMPLETE', 'Erison Ceballos', 'molinafabianarq@gmail.com', '19546828165', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-27T09:53:40'),
  ('RETO15D-hallertirado@gmail.com', 'PURCHASE_COMPLETE', 'John Martin', 'hallertirado@gmail.com', '528112865979', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-05-27T10:34:03'),
  ('RETO15D-billonariolatino21k@gmail.com', 'PURCHASE_COMPLETE', 'Jota lopez', 'billonariolatino21k@gmail.com', '51931193061', 'PE', 'Reto 15D', 37.47, 'USD', 'active', '2025-05-27T19:45:32'),
  ('RETO15D-alejandrolorenzl@hotmail.com', 'PURCHASE_COMPLETE', 'Cesar Lobo', 'alejandrolorenzl@hotmail.com', '5491151214429', 'AR', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-27T20:14:06'),
  ('RETO15D-adnfitnessjujuy@gmail.com', 'PURCHASE_COMPLETE', 'MATIAS GERARDO PEREZ', 'adnfitnessjujuy@gmail.com', '543884971187', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-05-27T20:44:49'),
  ('RETO15D-dianamarcelarias@gmail.com', 'PURCHASE_COMPLETE', 'Diana marcela arias', 'dianamarcelarias@gmail.com', '18167267192', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-27T22:05:51'),
  ('RETO15D-integralbodybeauty@gmail.com', 'PURCHASE_COMPLETE', 'Yolanda Mendoza', 'integralbodybeauty@gmail.com', '17086858741', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-27T22:56:15'),
  ('RETO15D-danycaceresagnello@gmail.com', 'PURCHASE_COMPLETE', 'Dany Caceres', 'danycaceresagnello@gmail.com', '56982490210', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-27T23:05:34'),
  ('RETO15D-yenit_27@hotmail.com', 'PURCHASE_COMPLETE', 'Juliana Ramirez', 'yenit_27@hotmail.com', '50767472941', 'PA', 'Reto 15D', 37.00, 'USD', 'active', '2025-05-28T08:48:41'),
  ('RETO15D-ravellanedam@gmail.com', 'PURCHASE_COMPLETE', 'Ronald Avellaneda Montenegro', 'ravellanedam@gmail.com', '51932935809', 'PE', 'Reto 15D', 37.47, 'USD', 'active', '2025-05-28T08:57:23'),
  ('RETO15D-garciavasquezgabriel@gmail.com', 'PURCHASE_COMPLETE', 'Gabriel Garcia Vásquez', 'garciavasquezgabriel@gmail.com', '573112233887', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-28T10:15:54'),
  ('RETO15D-natalia03625@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Arboleda', 'natalia03625@gmail.com', '573177687420', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-28T12:09:29'),
  ('RETO15D-cristiangzesc@gmail.com', 'PURCHASE_COMPLETE', 'CRISTIAN GONZALEZ', 'cristiangzesc@gmail.com', '18315370105', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-28T23:43:56'),
  ('RETO15D-acgamboan@gmail.com', 'PURCHASE_COMPLETE', 'Aura Gamboa', 'acgamboan@gmail.com', '529982478663', 'MX', 'Reto 15D', 36.95, 'USD', 'active', '2025-05-29T05:19:16'),
  ('RETO15D-colombianaautosales@gmail.com', 'PURCHASE_COMPLETE', 'Leidy Quiroga', 'colombianaautosales@gmail.com', '14088029488', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-29T10:17:06'),
  ('RETO15D-sicaagustin2000@gmail.com', 'PURCHASE_COMPLETE', 'Agustin Sica', 'sicaagustin2000@gmail.com', '542915758527', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-29T11:03:38'),
  ('RETO15D-isabelsarca@gmail.com', 'PURCHASE_COMPLETE', 'diego fernando idarraga', 'isabelsarca@gmail.com', '573015625504', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-29T13:26:02'),
  ('RETO15D-juanybric@msn.com', 'PURCHASE_COMPLETE', 'Juany Bric', 'juanybric@msn.com', '14074704741', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-05-29T16:41:33'),
  ('RETO15D-melanievela43@gmail.com', 'PURCHASE_COMPLETE', 'Melania Velasquez', 'melanievela43@gmail.com', '50765174549', 'PA', 'Reto 15D', 36.99, 'USD', 'active', '2025-05-29T17:39:52'),
  ('RETO15D-nataliamorenocalle@gmail.com', 'PURCHASE_COMPLETE', 'Natalia Moreno', 'nataliamorenocalle@gmail.com', '573103218394', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-29T20:16:04'),
  ('RETO15D-julian.munozcruz@gmail.com', 'PURCHASE_COMPLETE', 'Julian Andrés munoz', 'julian.munozcruz@gmail.com', '573183889485', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-29T22:29:42'),
  ('RETO15D-javier.vasquezpalacios@hotmail.com', 'PURCHASE_COMPLETE', 'Javier Vásquez Palacios', 'javier.vasquezpalacios@hotmail.com', '51981518535', 'PE', 'Reto 15D', 37.06, 'USD', 'active', '2025-05-30T09:22:08'),
  ('RETO15D-lidumonasterio11@gmail.com', 'PURCHASE_COMPLETE', 'Odra Velásquez', 'lidumonasterio11@gmail.com', '56945090711', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-30T09:45:51'),
  ('RETO15D-agenciainmobiliariacancun@gmail.com', 'PURCHASE_COMPLETE', 'Iveth Morales', 'agenciainmobiliariacancun@gmail.com', '529988410165', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-05-30T14:40:36'),
  ('RETO15D-fredy.gamarra.z@gmail.com', 'PURCHASE_COMPLETE', 'Fredy Gamarra Zárate', 'fredy.gamarra.z@gmail.com', '51956858541', 'PE', 'Reto 15D', 37.01, 'USD', 'active', '2025-05-30T17:16:26'),
  ('RETO15D-aponteyaz201701@gmail.com', 'PURCHASE_COMPLETE', 'Yasmin Aponte', 'aponteyaz201701@gmail.com', '573007946596', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-31T06:09:50'),
  ('RETO15D-sharikdnanda456@gmail.com', 'PURCHASE_COMPLETE', 'Sharikd Esteban', 'sharikdnanda456@gmail.com', '573215530423', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-31T07:17:25'),
  ('RETO15D-ivonnealfonso28@gmail.com', 'PURCHASE_COMPLETE', 'Ivonne Alfonso', 'ivonnealfonso28@gmail.com', '573106095237', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-31T07:53:42'),
  ('RETO15D-cajitamelosa@gmail.com', 'PURCHASE_COMPLETE', 'Johana Mosquera', 'cajitamelosa@gmail.com', '573053199030', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-05-31T13:23:11'),
  ('RETO15D-lesanabriaochoa@gmail.com', 'PURCHASE_COMPLETE', 'Luz Estefania Sanabria', 'lesanabriaochoa@gmail.com', '573005390196', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-01T09:51:16'),
  ('RETO15D-fabiansuperseya@gmail.com', 'PURCHASE_COMPLETE', 'Fabian Monroy', 'fabiansuperseya@gmail.com', '573147882175', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-01T17:41:19'),
  ('RETO15D-alexander.koteskys@gmail.com', 'PURCHASE_COMPLETE', 'Alexander kotesky', 'alexander.koteskys@gmail.com', '56992993991', 'CL', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-01T18:07:30'),
  ('RETO15D-jom7215jom@gmail.com', 'PURCHASE_COMPLETE', 'Judith Orosco', 'jom7215jom@gmail.com', '51947487700', 'PE', 'Reto 15D', 37.01, 'USD', 'active', '2025-06-01T18:19:54'),
  ('RETO15D-karenarodriguezg@gmail.com', 'PURCHASE_COMPLETE', 'Karen rodriguez', 'karenarodriguezg@gmail.com', '112109145241', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-01T19:25:07'),
  ('RETO15D-alexafreitez27@gmail.com', 'PURCHASE_COMPLETE', 'Alexa Freitez', 'alexafreitez27@gmail.com', '573013415651', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-01T20:11:12'),
  ('RETO15D-florencia@inuitlab.com', 'PURCHASE_COMPLETE', 'Florencia Sandjian', 'florencia@inuitlab.com', '541155746104', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-06-01T23:35:52'),
  ('RETO15D-jose.viropa@gmail.com', 'PURCHASE_COMPLETE', 'Jose Romero Paredes', 'jose.viropa@gmail.com', '13322837607', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-01T23:36:22'),
  ('RETO15D-rayquipa@hotmail.com', 'PURCHASE_COMPLETE', 'Rocio ayquipa', 'rayquipa@hotmail.com', '51997508018', 'PE', 'Reto 15D', 37.01, 'USD', 'active', '2025-06-01T23:54:50'),
  ('RETO15D-aryamfrigia@gmail.com', 'PURCHASE_COMPLETE', 'Adriana Fdez', 'aryamfrigia@gmail.com', '529983389040', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-06-02T06:49:39'),
  ('RETO15D-mariaalexandragk@gmail.com', 'PURCHASE_COMPLETE', 'Maria Alexandra Alexandra', 'mariaalexandragk@gmail.com', '19546550399', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-02T07:23:30'),
  ('RETO15D-nellyfloresegocheaga@gmail.com', 'PURCHASE_COMPLETE', 'Nelly Sevelyn Flores Egocheaga', 'nellyfloresegocheaga@gmail.com', '51957357657', 'PE', 'Reto 15D', 37.01, 'USD', 'active', '2025-06-02T07:36:02'),
  ('RETO15D-majopillo09@gmail.com', 'PURCHASE_COMPLETE', 'Angélica urrea', 'majopillo09@gmail.com', '573246719337', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-02T08:28:37'),
  ('RETO15D-redondo.paola@gmail.com', 'PURCHASE_COMPLETE', 'Paola Redondo', 'redondo.paola@gmail.com', '573114348345', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-02T10:59:56'),
  ('RETO15D-aylin.alfaror@gmail.com', 'PURCHASE_COMPLETE', 'Aylin Guadalupe Alfaro Reyes', 'aylin.alfaror@gmail.com', '525610163221', 'MX', 'Reto 15D', 36.99, 'USD', 'active', '2025-06-02T12:45:07'),
  ('RETO15D-denisseortiz35@gmail.com', 'PURCHASE_COMPLETE', 'Denisse Ortiz', 'denisseortiz35@gmail.com', '19365486090', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-02T14:09:28'),
  ('RETO15D-imjoyasplata@gmail.com', 'PURCHASE_COMPLETE', 'Maximiliano Diez', 'imjoyasplata@gmail.com', '543644370217', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-06-02T15:33:09'),
  ('RETO15D-paosinrumbo@gmail.com', 'PURCHASE_COMPLETE', 'Paola Sáenz', 'paosinrumbo@gmail.com', '573209469695', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-02T17:56:35'),
  ('RETO15D-lourdesvrealtor@gmail.com', 'PURCHASE_COMPLETE', 'Lourdes Valladares', 'lourdesvrealtor@gmail.com', '51991894043', 'PE', 'Reto 15D', 37.05, 'USD', 'active', '2025-06-02T22:39:45'),
  ('RETO15D-wendybiflo@hotmail.com', 'PURCHASE_COMPLETE', 'Wendy Villamil florez', 'wendybiflo@hotmail.com', '119735365940', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-03T01:20:33'),
  ('RETO15D-lu2montene@gmail.com', 'PURCHASE_COMPLETE', 'Luis Montenegro', 'lu2montene@gmail.com', '593993493312', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-03T05:24:32'),
  ('RETO15D-edgarfaviani@gmail.com', 'PURCHASE_COMPLETE', 'Edgar Faviani', 'edgarfaviani@gmail.com', '50761225667', 'PA', 'Reto 15D', 37.03, 'USD', 'active', '2025-06-03T06:21:57'),
  ('RETO15D-mariaelcycardozomartinez@gmail.com', 'PURCHASE_COMPLETE', 'Maria Elcy Cardozo', 'mariaelcycardozomartinez@gmail.com', '573209138604', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T06:26:48'),
  ('RETO15D-natalycreativa@hotmail.com', 'PURCHASE_COMPLETE', 'Nataly Sierra Clavijo', 'natalycreativa@hotmail.com', '573105030165', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T07:19:41'),
  ('RETO15D-carfel42@hotmail.com', 'PURCHASE_COMPLETE', 'Carlos Vaca', 'carfel42@hotmail.com', '5930958867583', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-03T08:05:53'),
  ('RETO15D-angie.silva.9807@gmail.com', 'PURCHASE_COMPLETE', 'angie camila silva jáuregui', 'angie.silva.9807@gmail.com', '573123443074', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T08:23:07'),
  ('RETO15D-mailithbustamante@gmail.com', 'PURCHASE_COMPLETE', 'Mailyth mileth', 'mailithbustamante@gmail.com', '573216176734', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T08:56:29'),
  ('RETO15D-saratuxtra@gmail.com', 'PURCHASE_COMPLETE', 'Sara Ibanez', 'saratuxtra@gmail.com', '18504057183', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-03T09:11:28'),
  ('RETO15D-erita28_9@hotmail.com', 'PURCHASE_COMPLETE', 'Erika Guerrero', 'erita28_9@hotmail.com', '573003527777', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T10:36:39'),
  ('RETO15D-vivi.galindo83@outlook.com', 'PURCHASE_COMPLETE', 'Olga Viviana Galindo Angulo', 'vivi.galindo83@outlook.com', '573118814313', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T13:20:21'),
  ('RETO15D-slpconstruction81@gmail.com', 'PURCHASE_COMPLETE', 'Pablo Guevara', 'slpconstruction81@gmail.com', '12818545647', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-03T13:51:55'),
  ('RETO15D-veronicacuartassuarez@gmail.com', 'PURCHASE_COMPLETE', 'Veronica Cuartas Suarez', 'veronicacuartassuarez@gmail.com', '573225569806', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T16:00:54'),
  ('RETO15D-joanna_amaral@live.com', 'PURCHASE_COMPLETE', 'Joana Amaral', 'joanna_amaral@live.com', '541160950329', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-06-03T18:31:07'),
  ('RETO15D-khatebolivarugc@gmail.com', 'PURCHASE_COMPLETE', 'Khaterine Bolívar Quiroz', 'khatebolivarugc@gmail.com', '573194154148', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-03T18:40:39'),
  ('RETO15D-angie_0231@hotmail.com', 'PURCHASE_COMPLETE', 'Angie Johanna Parra Niño', 'angie_0231@hotmail.com', '17865387662', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-03T18:49:01'),
  ('RETO15D-claudiadelahoz@hotmail.com', 'PURCHASE_COMPLETE', 'de la Hoz, Claudia Haydee', 'claudiadelahoz@hotmail.com', '5491150575606', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-06-03T22:35:59'),
  ('RETO15D-jimematacin@gmail.com', 'PURCHASE_COMPLETE', 'Jimena Matacin', 'jimematacin@gmail.com', '543414471371', 'AR', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-04T01:44:43'),
  ('RETO15D-paoaristizabal1@hotmail.com', 'PURCHASE_COMPLETE', 'Paola Aristizábal Aristizabal', 'paoaristizabal1@hotmail.com', '573013451881', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-06-04T06:34:22'),
  ('RETO15D-mcamilams2022@gmail.com', 'PURCHASE_COMPLETE', 'Camila Marquez', 'mcamilams2022@gmail.com', '573147010438', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-04T09:33:23'),
  ('RETO15D-rosarioochoa1102@gmail.com', 'PURCHASE_COMPLETE', 'Rosario Ochoa', 'rosarioochoa1102@gmail.com', '573022346431', 'CO', 'Reto 15D', 36.92, 'USD', 'active', '2025-06-04T14:43:49'),
  ('RETO15D-dperfectos@hotmail.com', 'PURCHASE_COMPLETE', 'Delma Perfecto', 'dperfectos@hotmail.com', '16192791848', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-04T15:54:50'),
  ('RETO15D-gilberto@gobemax.com', 'PURCHASE_COMPLETE', 'Ronald G Laparra', 'gilberto@gobemax.com', '14805803590', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-04T16:04:45'),
  ('RETO15D-c.gerardomontalvo@gmail.com', 'PURCHASE_COMPLETE', 'Gerardo Montalvo Sanchez', 'c.gerardomontalvo@gmail.com', '525576605992', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-06-04T18:41:44'),
  ('RETO15D-spalzate@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Alzate', 'spalzate@gmail.com', '573108307034', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-04T19:03:26'),
  ('RETO15D-gsefair@gmail.com', 'PURCHASE_COMPLETE', 'Georges Sefair', 'gsefair@gmail.com', '573226855866', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-04T20:09:23'),
  ('RETO15D-crew@clandestinostudio.com', 'PURCHASE_COMPLETE', 'Clamdestino studio', 'crew@clandestinostudio.com', '524776595449', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-06-05T08:17:59'),
  ('RETO15D-di.chiriboga@gmail.com', 'PURCHASE_COMPLETE', 'Diana Chiriboga', 'di.chiriboga@gmail.com', '593987289953', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-05T08:51:12'),
  ('RETO15D-mauricioorjuela18@gmail.com', 'PURCHASE_COMPLETE', 'Mauricio orjuela', 'mauricioorjuela18@gmail.com', '16146497069', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-05T09:11:26'),
  ('RETO15D-morios.oficial@gmail.com', 'PURCHASE_COMPLETE', 'Alejandra Morón', 'morios.oficial@gmail.com', '573214092936', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-05T09:16:07'),
  ('RETO15D-fandosvictoria@gmail.com', 'PURCHASE_COMPLETE', 'Victoria luz Fandos', 'fandosvictoria@gmail.com', '541164102003', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-06-05T09:20:24'),
  ('RETO15D-3amultiservicesllc@gmail.com', 'PURCHASE_COMPLETE', 'Angie Diaz', '3amultiservicesllc@gmail.com', '118623889534', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-05T11:42:32'),
  ('RETO15D-formacionfuturoglobal@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Ruiz', 'formacionfuturoglobal@gmail.com', '112016475382', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-05T18:26:35'),
  ('RETO15D-johan.fuen@gmail.com', 'PURCHASE_COMPLETE', 'JOHAN FUENTES LOZANO', 'johan.fuen@gmail.com', '573007869035', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-05T18:38:25'),
  ('RETO15D-bronsillon90@hotmail.com', 'PURCHASE_COMPLETE', 'Carlos Garcia', 'bronsillon90@hotmail.com', '5930983023711', 'EC', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-05T22:23:40'),
  ('RETO15D-graphic.halland@gmail.com', 'PURCHASE_COMPLETE', 'HALLAND HERNANDEZ', 'graphic.halland@gmail.com', '56991224499', 'CL', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-06T02:06:11'),
  ('RETO15D-bernallcarloss21@gmail.com', 'PURCHASE_COMPLETE', 'Juan Carlos', 'bernallcarloss21@gmail.com', '527714200169', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-06-06T08:45:19'),
  ('RETO15D-nydia_beltran@yahoo.com.mx', 'PURCHASE_COMPLETE', 'Nydia Beltran', 'nydia_beltran@yahoo.com.mx', '525554199234', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-06-06T09:01:29'),
  ('RETO15D-mariaaquije35@gmail.com', 'PURCHASE_COMPLETE', 'María Aquije', 'mariaaquije35@gmail.com', '51959555698', 'PE', 'Reto 15D', 36.94, 'USD', 'active', '2025-06-06T10:51:02'),
  ('RETO15D-pau.cbe2530@gmail.com', 'PURCHASE_COMPLETE', 'Paula bardalez', 'pau.cbe2530@gmail.com', '51970360163', 'PE', 'Reto 15D', 36.94, 'USD', 'active', '2025-06-06T11:05:07'),
  ('RETO15D-luigi.alcalde@gmail.com', 'PURCHASE_COMPLETE', 'Luigi Alcalde', 'luigi.alcalde@gmail.com', '51940428043', 'PE', 'Reto 15D', 36.94, 'USD', 'active', '2025-06-06T12:54:31'),
  ('RETO15D-carlosjosuemz8@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Marquez', 'carlosjosuemz8@gmail.com', '526145348986', 'MX', 'Reto 15D', 37.01, 'USD', 'active', '2025-06-06T13:23:23'),
  ('RETO15D-karennataliaflorez457@gmail.com', 'PURCHASE_COMPLETE', 'KAREN NATALIA FLOREZ', 'karennataliaflorez457@gmail.com', '573124650297', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-06T18:54:31'),
  ('RETO15D-ramvaleria61@gmail.com', 'PURCHASE_COMPLETE', 'Valeria Estefania Ramirez Duarte', 'ramvaleria61@gmail.com', '525580996901', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-06-06T20:43:21'),
  ('RETO15D-aldo@aldocivico.com', 'PURCHASE_COMPLETE', 'Aldo Civico', 'aldo@aldocivico.com', '16464920372', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-07T04:10:24'),
  ('RETO15D-janissantaella@yahoo.com', 'PURCHASE_COMPLETE', 'Janis Santaella', 'janissantaella@yahoo.com', '18097297600', 'DO', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-07T06:49:35'),
  ('RETO15D-jonavypiedrahita@gmail.com', 'PURCHASE_COMPLETE', 'Jonavy Piedtahita', 'jonavypiedrahita@gmail.com', '573216610543', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-07T21:05:57'),
  ('RETO15D-elianapg9294@gmail.com', 'PURCHASE_COMPLETE', 'Eliana pena gaitan', 'elianapg9294@gmail.com', '14438810280', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-08T07:23:05'),
  ('RETO15D-jorgeramirezdocenciadeportiva@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Ramìrez', 'jorgeramirezdocenciadeportiva@gmail.com', '525518385601', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-06-08T07:33:24'),
  ('RETO15D-realty.golden@gmail.com', 'PURCHASE_COMPLETE', 'Erver Hernández', 'realty.golden@gmail.com', '573175115296', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-08T07:53:54'),
  ('RETO15D-rodriguez22_ashlee@hotmail.com', 'PURCHASE_COMPLETE', 'Ashlee estefania rodriguez ramirez', 'rodriguez22_ashlee@hotmail.com', '524612350988', 'MX', 'Reto 15D', 37.00, 'USD', 'active', '2025-06-08T08:52:31'),
  ('RETO15D-fabiobayonarios@gmail.com', 'PURCHASE_COMPLETE', 'Albert Bayon', 'fabiobayonarios@gmail.com', '573102859646', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-08T10:29:39'),
  ('RETO15D-monimerchan@gmail.com', 'PURCHASE_COMPLETE', 'Monica Merchan', 'monimerchan@gmail.com', '573154217882', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-08T14:24:20'),
  ('RETO15D-julirolspper@gmail.com', 'PURCHASE_COMPLETE', 'Carlos Julián', 'julirolspper@gmail.com', '573118369652', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-08T20:43:48'),
  ('RETO15D-jonathan.mrh@outlook.com', 'PURCHASE_COMPLETE', 'Jonathan Mabiel Rodas Hernandez', 'jonathan.mrh@outlook.com', '529511302789', 'MX', 'Reto 15D', 36.96, 'USD', 'active', '2025-06-10T09:15:58'),
  ('RETO15D-dpolania92@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Polania', 'dpolania92@gmail.com', '573206194519', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-13T09:58:24'),
  ('RETO15D-atomatizaciones.ctrl.v@gmail.com', 'PURCHASE_COMPLETE', 'Jhasson Gonzalez', 'atomatizaciones.ctrl.v@gmail.com', '573058264115', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-13T14:28:59'),
  ('RETO15D-mateolambisgomez9@gmail.com', 'PURCHASE_COMPLETE', 'Mateo Lambis Gómez', 'mateolambisgomez9@gmail.com', '573104678471', 'CO', 'Reto 15D', 36.93, 'USD', 'active', '2025-06-21T16:02:01'),
  ('RETO15D-julianarias502@gmail.com', 'PURCHASE_COMPLETE', 'Juliana Arias briceño', 'julianarias502@gmail.com', '541127842934', 'AR', 'Reto 15D', 38.33, 'USD', 'active', '2025-06-24T12:43:13'),
  ('RETO15D-paul_pb15@hotmail.com', 'PURCHASE_COMPLETE', 'Paul Pintado', 'paul_pb15@hotmail.com', '113474015905', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-24T15:10:04'),
  ('RETO15D-latindjsoc@gmail.com', 'PURCHASE_COMPLETE', 'Paco Villegas', 'latindjsoc@gmail.com', '17146316598', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-24T17:26:37'),
  ('RETO15D-joseok86@gmail.com', 'PURCHASE_COMPLETE', 'Jose Oquendo', 'joseok86@gmail.com', '116562412491', 'US', 'Reto 15D', 35.00, 'USD', 'active', '2025-06-24T18:21:31'),
  ('RETO15D-dorothy.gonzalez@figoservices.com', 'PURCHASE_COMPLETE', 'Dorothy Gonzalez', 'dorothy.gonzalez@figoservices.com', '50766178794', 'PA', 'Reto 15D', 37.02, 'USD', 'active', '2025-06-24T19:13:31'),
  ('RETO15D-rgonzalez@asesoriasglobales.cl', 'PURCHASE_COMPLETE', 'Rodrigo González', 'rgonzalez@asesoriasglobales.cl', '56963008502', 'CL', 'Reto 15D', 36.57, 'USD', 'active', '2025-06-24T21:58:01'),
  ('RETO15D-soyricardocastillo222@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo Castillo', 'soyricardocastillo222@gmail.com', '15715521954', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-25T05:44:40'),
  ('RETO15D-barradd@gmail.com', 'PURCHASE_COMPLETE', 'Deyanira Barragan del Olmo', 'barradd@gmail.com', '525518466961', 'MX', 'Reto 15D', 36.58, 'USD', 'active', '2025-06-25T09:52:47'),
  ('RETO15D-jans1609@gmail.com', 'PURCHASE_COMPLETE', 'Jorge Antonio', 'jans1609@gmail.com', '524611249522', 'MX', 'Reto 15D', 36.58, 'USD', 'active', '2025-06-25T10:01:52'),
  ('RETO15D-topetelm@gmail.com', 'PURCHASE_COMPLETE', 'Luis Miguel Topete', 'topetelm@gmail.com', '524423764202', 'MX', 'Reto 15D', 36.61, 'USD', 'active', '2025-06-25T18:00:44'),
  ('RETO15D-lcatalina.valencia@gmail.com', 'PURCHASE_COMPLETE', 'Catalina Valencia', 'lcatalina.valencia@gmail.com', '573217770986', 'CO', 'Reto 15D', 0.37, 'USD', 'active', '2025-06-25T18:52:10'),
  ('RETO15D-shantajo@hotmail.com', 'PURCHASE_COMPLETE', 'Santiago lopez', 'shantajo@hotmail.com', '573008513675', 'CO', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-25T22:55:09'),
  ('RETO15D-mishellecjg@hotmail.com', 'PURCHASE_COMPLETE', 'Mishelle Jimenez G', 'mishellecjg@hotmail.com', '528712779377', 'MX', 'Reto 15D', 36.61, 'USD', 'active', '2025-06-26T01:38:34'),
  ('RETO15D-laura.bunge@icloud.com', 'PURCHASE_COMPLETE', 'Laura Bunge', 'laura.bunge@icloud.com', '541141461135', 'AR', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-26T08:36:06'),
  ('RETO15D-jhonatan1993aaguilar@gmail.com', 'PURCHASE_COMPLETE', 'Jhonatan Aguilar', 'jhonatan1993aaguilar@gmail.com', '573213749819', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-06-27T07:59:40'),
  ('RETO15D-j4tzu3@gmail.com', 'PURCHASE_COMPLETE', 'Jatsue rosario', 'j4tzu3@gmail.com', '541135769434', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-27T13:51:10'),
  ('RETO15D-manu.valladares90@gmail.com', 'PURCHASE_COMPLETE', 'Manuel Valladares Sandoval', 'manu.valladares90@gmail.com', '56950006278', 'CL', 'Reto 15D', 36.57, 'USD', 'active', '2025-06-27T22:18:50'),
  ('RETO15D-maryohaa277@gmail.com', 'PURCHASE_COMPLETE', 'Maritza Yohanna Angarita Escobar', 'maryohaa277@gmail.com', '573042919149', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-06-28T06:58:15'),
  ('RETO15D-jorgelinadc@gmail.com', 'PURCHASE_COMPLETE', 'Jorgelina Diaz Cabrera', 'jorgelinadc@gmail.com', '5401125296009', 'AR', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-28T09:05:37'),
  ('RETO15D-argesestudios@gmail.com', 'PURCHASE_COMPLETE', 'Víctor Martinez', 'argesestudios@gmail.com', '573104000858', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-06-28T11:10:31'),
  ('RETO15D-rosierod24@gmail.com', 'PURCHASE_COMPLETE', 'Rosie Rodriguez', 'rosierod24@gmail.com', '115129981223', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-28T15:07:01'),
  ('RETO15D-katyvilleg@gmail.com', 'PURCHASE_COMPLETE', 'Katiuska Villegas', 'katyvilleg@gmail.com', '117863789731', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-06-29T07:45:00'),
  ('RETO15D-oriettmarquez@hotmail.com', 'PURCHASE_COMPLETE', 'Oriett Marquez', 'oriettmarquez@hotmail.com', '528182804874', 'MX', 'Reto 15D', 37.03, 'USD', 'active', '2025-06-29T08:20:04'),
  ('RETO15D-geinermedinalopez9@gmail.com', 'PURCHASE_COMPLETE', 'Geiner Medina', 'geinermedinalopez9@gmail.com', '51963821055', 'PE', 'Reto 15D', 36.83, 'USD', 'active', '2025-07-01T06:22:05'),
  ('RETO15D-jbetts80@gmail.com', 'PURCHASE_COMPLETE', 'John Betts', 'jbetts80@gmail.com', '573184227932', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-01T08:06:35'),
  ('RETO15D-mariajosezamorano92@gmail.com', 'PURCHASE_COMPLETE', 'Maria jose zamorano santos', 'mariajosezamorano92@gmail.com', '573117531076', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-01T09:10:16'),
  ('RETO15D-equiposoporteeyj@gmail.com', 'PURCHASE_COMPLETE', 'Jhonatan Carrera', 'equiposoporteeyj@gmail.com', '5930992156293', 'EC', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-01T13:54:26'),
  ('RETO15D-mohaalm57@gmail.com', 'PURCHASE_COMPLETE', 'Mohamed Al mgitni', 'mohaalm57@gmail.com', '34632659293', 'ES', 'Reto 15D', 37.35, 'USD', 'active', '2025-07-01T14:16:03'),
  ('RETO15D-yvanmr777@gmail.com', 'PURCHASE_COMPLETE', 'Yvan Martinez Rengifo', 'yvanmr777@gmail.com', '17864884527', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-01T17:20:22'),
  ('RETO15D-mario.szp27@gmail.com', 'PURCHASE_COMPLETE', 'Mario Suarez Pimentel', 'mario.szp27@gmail.com', '526643452438', 'MX', 'Reto 15D', 36.62, 'USD', 'active', '2025-07-02T19:01:18'),
  ('RETO15D-alexasantysteban@hotmail.com', 'PURCHASE_COMPLETE', 'Claudia Alexandra Alfonso Galeano', 'alexasantysteban@hotmail.com', '593968161315', 'EC', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-02T23:31:16'),
  ('RETO15D-hbegazo@grupoissa.org', 'PURCHASE_COMPLETE', 'Hector Begazo', 'hbegazo@grupoissa.org', '51995097523', 'PE', 'Reto 15D', 36.76, 'USD', 'active', '2025-07-03T07:59:28'),
  ('RETO15D-noheliaestrad@msn.com', 'PURCHASE_COMPLETE', 'Nohelia Patricia Estrada Meza', 'noheliaestrad@msn.com', '5930994280626', 'EC', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-03T17:01:21'),
  ('RETO15D-yoli_gh@yahoo.com', 'PURCHASE_COMPLETE', 'Yoli ghisays', 'yoli_gh@yahoo.com', '573205165860', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-03T23:52:20'),
  ('RETO15D-academiahispanadepnl@gmail.com', 'PURCHASE_COMPLETE', 'Sergio Varela', 'academiahispanadepnl@gmail.com', '573002300784', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-04T07:10:30'),
  ('RETO15D-johnyposada@hotmail.com', 'PURCHASE_COMPLETE', 'Johny posada', 'johnyposada@hotmail.com', '573213654476', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-04T07:43:51'),
  ('RETO15D-paolamembrillo@yahoo.com.mx', 'PURCHASE_COMPLETE', 'Paola Membrillo', 'paolamembrillo@yahoo.com.mx', '523336766024', 'MX', 'Reto 15D', 36.94, 'USD', 'active', '2025-07-04T11:00:48'),
  ('RETO15D-karlalar@gmail.com', 'PURCHASE_COMPLETE', 'Karla lara', 'karlalar@gmail.com', '525529100162', 'MX', 'Reto 15D', 36.58, 'USD', 'active', '2025-07-04T14:46:13'),
  ('RETO15D-nenis.posso@gmail.com', 'PURCHASE_COMPLETE', 'Yarenis Posso', 'nenis.posso@gmail.com', '50766718205', 'PA', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-05T05:12:03'),
  ('RETO15D-niurka.jovanovich.luza@gmail.com', 'PURCHASE_COMPLETE', 'Niurka Jovanovich', 'niurka.jovanovich.luza@gmail.com', '51955041944', 'PE', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-05T07:41:51'),
  ('RETO15D-garzon.gustavoa@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo Garzon', 'garzon.gustavoa@gmail.com', '19045202332', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-05T11:41:01'),
  ('RETO15D-kenyadiaz@gmail.com', 'PURCHASE_COMPLETE', 'kenya pamela irina nuñez diaz', 'kenyadiaz@gmail.com', '525534463349', 'MX', 'Reto 15D', 36.98, 'USD', 'active', '2025-07-05T14:53:25'),
  ('RETO15D-canilla007@gmail.com', 'PURCHASE_COMPLETE', 'Luis Canilla', 'canilla007@gmail.com', '525518838788', 'MX', 'Reto 15D', 36.61, 'USD', 'active', '2025-07-06T13:28:43'),
  ('RETO15D-viwe.org@gmail.com', 'PURCHASE_COMPLETE', 'CARLOS MANUEL SANDOVAL CANDELAS', 'viwe.org@gmail.com', '523310216000', 'MX', 'Reto 15D', 36.64, 'USD', 'active', '2025-07-06T22:04:52'),
  ('RETO15D-kerimparra@gmail.com', 'PURCHASE_COMPLETE', 'Kerim Parra', 'kerimparra@gmail.com', '573016902572', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-08T11:39:00'),
  ('RETO15D-miguelmlemus@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Lemus', 'miguelmlemus@gmail.com', '573104229602', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-10T05:36:15'),
  ('RETO15D-luisfelipe1213@gmail.com', 'PURCHASE_COMPLETE', 'Luis Felipe perez Felipe perez', 'luisfelipe1213@gmail.com', '573017353297', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-10T05:49:20'),
  ('RETO15D-luzgmay@gmail.com', 'PURCHASE_COMPLETE', 'Luz Gonzalez', 'luzgmay@gmail.com', '573213024964', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-10T14:17:42'),
  ('RETO15D-maria.olavarri27@gmail.com', 'PURCHASE_COMPLETE', 'María Olavarri', 'maria.olavarri27@gmail.com', '529213034593', 'MX', 'Reto 15D', 36.60, 'USD', 'active', '2025-07-11T19:17:02'),
  ('RETO15D-tatianaserna1209@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Serna', 'tatianaserna1209@gmail.com', '573105390886', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-11T21:34:50'),
  ('RETO15D-danielpinillarojas@gmail.com', 'PURCHASE_COMPLETE', 'Daniel Pinilla', 'danielpinillarojas@gmail.com', '573143581033', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-12T05:59:21'),
  ('RETO15D-monarchoficial@gmail.com', 'PURCHASE_COMPLETE', 'Alex Gómez Ruiz', 'monarchoficial@gmail.com', '573022924339', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-12T12:14:11'),
  ('RETO15D-yurgennyrosario@gmail.com', 'PURCHASE_COMPLETE', 'Yurgenny Rosario', 'yurgennyrosario@gmail.com', '15162691986', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-12T13:10:47'),
  ('RETO15D-roberttolentopro@gmail.com', 'PURCHASE_COMPLETE', 'Robert Tolentino', 'roberttolentopro@gmail.com', '51971427144', 'PE', 'Reto 15D', 36.87, 'USD', 'active', '2025-07-12T21:12:52'),
  ('RETO15D-marcela3443.34@gmail.com', 'PURCHASE_COMPLETE', 'MARCELA MORENO', 'marcela3443.34@gmail.com', '573002825440', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-13T18:04:26'),
  ('RETO15D-chiko228@gmail.com', 'PURCHASE_COMPLETE', 'Jhon faber Ciro', 'chiko228@gmail.com', '573002963838', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-13T18:37:15'),
  ('RETO15D-lourdes14772@gmail.com', 'PURCHASE_COMPLETE', 'Lourdes Garcia', 'lourdes14772@gmail.com', '15518040714', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-07-14T20:31:12'),
  ('RETO15D-bgsaplicaciones@gmail.com', 'PURCHASE_COMPLETE', 'Julián Galviz', 'bgsaplicaciones@gmail.com', '573153186241', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-14T22:01:50'),
  ('RETO15D-yisethbeltran2006@gmail.com', 'PURCHASE_COMPLETE', 'María Beltrán', 'yisethbeltran2006@gmail.com', '573113363502', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-15T12:01:22'),
  ('RETO15D-magima89@gmail.com', 'PURCHASE_COMPLETE', 'Manuel Gil', 'magima89@gmail.com', '573177346317', 'CO', 'Reto 15D', 36.56, 'USD', 'active', '2025-07-15T13:23:07'),
  ('RETO15D-dratatianaceballos@gmail.com', 'PURCHASE_COMPLETE', 'Tatiana Ceballos Bautista', 'dratatianaceballos@gmail.com', '573208064392', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-15T14:18:06'),
  ('RETO15D-gadn88@gmail.com', 'PURCHASE_COMPLETE', 'Gustavo duque', 'gadn88@gmail.com', '573234253036', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-17T20:19:35'),
  ('RETO15D-vcamargod2016@gmail.com', 'PURCHASE_COMPLETE', 'Victor Camargo D', 'vcamargod2016@gmail.com', '573014849722', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-17T21:06:07'),
  ('RETO15D-oscarjavierpizza@gmail.com', 'PURCHASE_COMPLETE', 'Javier Pizza', 'oscarjavierpizza@gmail.com', '573192209773', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-19T17:53:49'),
  ('RETO15D-yeraldintriana09@gmail.com', 'PURCHASE_COMPLETE', 'Yeraldin Triana aponte', 'yeraldintriana09@gmail.com', '573214227683', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-20T06:33:38'),
  ('RETO15D-manuelaepedesign@gmail.com', 'PURCHASE_COMPLETE', 'Manuela Epe', 'manuelaepedesign@gmail.com', '573136875700', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-20T20:07:30'),
  ('RETO15D-johanita.trusca@gmail.com', 'PURCHASE_COMPLETE', 'Johana caicedo', 'johanita.trusca@gmail.com', '573106904141', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-20T21:50:35'),
  ('RETO15D-evaromeror@yahoo.com', 'PURCHASE_COMPLETE', 'Eva Romero', 'evaromeror@yahoo.com', '573178581791', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-21T03:57:49'),
  ('RETO15D-hola@elalgo.co', 'PURCHASE_COMPLETE', 'Tatiana Lopez', 'hola@elalgo.co', '573208335919', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-21T09:08:28'),
  ('RETO15D-vivian.andrea0131@gmail.com', 'PURCHASE_COMPLETE', 'Viviana Córdoba', 'vivian.andrea0131@gmail.com', '573147980314', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-22T17:49:41'),
  ('RETO15D-tabaresarboleda@gmail.com', 'PURCHASE_COMPLETE', 'Julian Tabares', 'tabaresarboleda@gmail.com', '573006904212', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-23T08:38:59'),
  ('RETO15D-pabrilda7314@icloud.com', 'PURCHASE_COMPLETE', 'Paula andrea abril Daza', 'pabrilda7314@icloud.com', '573132046717', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-23T21:55:03'),
  ('RETO15D-yeber32@gmail.com', 'PURCHASE_COMPLETE', 'Davian Vargas', 'yeber32@gmail.com', '573214099228', 'CO', 'Reto 15D', 0.21, 'USD', 'active', '2025-07-24T00:47:38'),
  ('RETO15D-verokar2008@gmail.com', 'PURCHASE_COMPLETE', 'Veronica castro', 'verokar2008@gmail.com', '573138173409', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-27T11:42:38'),
  ('RETO15D-maristizabalh@gmail.com', 'PURCHASE_COMPLETE', 'Martin Aristizabal Henao', 'maristizabalh@gmail.com', '573205218908', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-28T02:31:43'),
  ('RETO15D-fabianimacias81@gmail.com', 'PURCHASE_COMPLETE', 'Yonier Fabiani Samboni Macias', 'fabianimacias81@gmail.com', '573202216183', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-28T16:47:09'),
  ('RETO15D-solcitysas@gmail.com', 'PURCHASE_COMPLETE', 'leonardo fula', 'solcitysas@gmail.com', '573124305684', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-29T22:32:06'),
  ('RETO15D-adecorarbyamb@gmail.com', 'PURCHASE_COMPLETE', 'Anny Bolivar', 'adecorarbyamb@gmail.com', '573128019812', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-30T15:50:24'),
  ('RETO15D-novahubmk@gmail.com', 'PURCHASE_COMPLETE', 'Stephany Benavides', 'novahubmk@gmail.com', '573102099522', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-30T16:41:51'),
  ('RETO15D-lopezarellanojuanfrancisco@gmail.com', 'PURCHASE_COMPLETE', 'Juan Francisco Lopez Arellano', 'lopezarellanojuanfrancisco@gmail.com', '523329318185', 'MX', 'Reto 15D', 36.60, 'USD', 'active', '2025-07-30T16:45:36'),
  ('RETO15D-cristianspn5417@gmail.com', 'PURCHASE_COMPLETE', 'Cristian steban arcila fonseca', 'cristianspn5417@gmail.com', '34614668085', 'ES', 'Reto 15D', 38.40, 'USD', 'active', '2025-07-31T04:23:08'),
  ('RETO15D-candela-007@hotmail.com', 'PURCHASE_COMPLETE', 'Jeisson candela', 'candela-007@hotmail.com', '573112497579', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-31T07:04:18'),
  ('RETO15D-lauvaler665@gmail.com', 'PURCHASE_COMPLETE', 'LAURA RODRIGUEZ', 'lauvaler665@gmail.com', '573202961181', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-07-31T15:07:28'),
  ('RETO15D-infomajestuosamk@gmail.com', 'PURCHASE_COMPLETE', 'Yuri Zambrano', 'infomajestuosamk@gmail.com', '34672603899', 'ES', 'Reto 15D', 36.72, 'USD', 'active', '2025-08-01T16:20:40'),
  ('RETO15D-bjdazap@gmail.com', 'PURCHASE_COMPLETE', 'Billy Daza Pérez', 'bjdazap@gmail.com', '573103526645', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-02T10:30:20'),
  ('RETO15D-rriveramaria@gmail.com', 'PURCHASE_COMPLETE', 'Maria Rivera', 'rriveramaria@gmail.com', '573113524085', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-02T15:10:27'),
  ('RETO15D-alex-2027@hotmail.com', 'PURCHASE_COMPLETE', 'Alexander Arroyave', 'alex-2027@hotmail.com', '573205904145', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-02T19:17:04'),
  ('RETO15D-carolinerojasb10@gmail.com', 'PURCHASE_COMPLETE', 'Caroline Rojas', 'carolinerojasb10@gmail.com', '34652230622', 'ES', 'Reto 15D', 36.74, 'USD', 'active', '2025-08-03T02:56:04'),
  ('RETO15D-salazarsanchezlinafernanda1@gmail.com', 'PURCHASE_COMPLETE', 'Lina Fernanda Salazar Sánchez', 'salazarsanchezlinafernanda1@gmail.com', '573168435067', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-03T11:15:44'),
  ('RETO15D-cesarlozada300@gmail.com', 'PURCHASE_COMPLETE', 'Cesar lozada', 'cesarlozada300@gmail.com', '593994681219', 'EC', 'Reto 15D', 34.66, 'USD', 'active', '2025-08-04T15:40:59'),
  ('RETO15D-angie.chavez180497@gmail.com', 'PURCHASE_COMPLETE', 'Angie Chávez', 'angie.chavez180497@gmail.com', '5930991379955', 'EC', 'Reto 15D', 34.66, 'USD', 'active', '2025-08-05T10:32:40'),
  ('RETO15D-luismiguel.aguirre17@gmail.com', 'PURCHASE_COMPLETE', 'Luis Miguel Aguirre Gomez', 'luismiguel.aguirre17@gmail.com', '573127130888', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-05T22:01:36'),
  ('RETO15D-jareroluis@gmail.com', 'PURCHASE_COMPLETE', 'Luis Carlos Jarero Martínez', 'jareroluis@gmail.com', '524761509858', 'MX', 'Reto 15D', 36.66, 'USD', 'active', '2025-08-06T22:07:35'),
  ('RETO15D-jose0717k@gmail.com', 'PURCHASE_COMPLETE', 'Jose Jaramillo', 'jose0717k@gmail.com', '573014410645', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-14T20:07:49'),
  ('RETO15D-anamas06@hotmail.com', 'PURCHASE_COMPLETE', 'Ana María Sánchez', 'anamas06@hotmail.com', '573151131504', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-17T09:51:13'),
  ('RETO15D-digitalxpresscali@gmail.com', 'PURCHASE_COMPLETE', 'gabriela florez', 'digitalxpresscali@gmail.com', '573216142097', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-08-28T09:24:20'),
  ('RETO15D-marcosf.amadoc@gmail.com', 'PURCHASE_COMPLETE', 'Marcos Amado', 'marcosf.amadoc@gmail.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-01T18:14:49'),
  ('RETO15D-doracaicedo71@gmail.com', 'PURCHASE_COMPLETE', 'Dora morales', 'doracaicedo71@gmail.com', '13233989357', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-09-02T16:43:14'),
  ('RETO15D-esther051996@gmail.com', 'PURCHASE_COMPLETE', 'Esther Guzman', 'esther051996@gmail.com', '573226624171', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-02T17:11:55'),
  ('RETO15D-erickmonsalvev@gmail.com', 'PURCHASE_COMPLETE', 'Erick monsalve', 'erickmonsalvev@gmail.com', '112019899408', 'US', 'Reto 15D', 34.66, 'USD', 'active', '2025-09-03T13:16:21'),
  ('RETO15D-eloisa.arcos@globalbit.co', 'PURCHASE_COMPLETE', 'Eloisa arcos', 'eloisa.arcos@globalbit.co', '573163681382', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-05T21:58:31'),
  ('RETO15D-gabamkd@gmail.com', 'PURCHASE_COMPLETE', 'GIOVANNY ALEXANDER BEDOYA ATEHORTUA', 'gabamkd@gmail.com', '34603011384', 'ES', 'Reto 15D', 37.13, 'USD', 'active', '2025-09-06T05:59:39'),
  ('RETO15D-allan.pacheco.calderon@gmail.com', 'PURCHASE_COMPLETE', 'Allan Pacheco Calderón', 'allan.pacheco.calderon@gmail.com', NULL, 'CL', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-07T21:16:17'),
  ('RETO15D-felipeolave@yahoo.com', 'PURCHASE_COMPLETE', 'Andrés Olave', 'felipeolave@yahoo.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-08T16:25:05'),
  ('RETO15D-musico_118@hotmail.com', 'PURCHASE_COMPLETE', 'Walter Ovalle Gutiérrez', 'musico_118@hotmail.com', '573133707065', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-08T23:21:07'),
  ('RETO15D-kevinp96.kp@gmail.com', 'PURCHASE_COMPLETE', 'Kevin Alan Fabela', 'kevinp96.kp@gmail.com', '527223716048', 'MX', 'Reto 15D', 36.97, 'USD', 'active', '2025-09-09T10:54:00'),
  ('RETO15D-lupibeltrame2@gmail.com', 'PURCHASE_COMPLETE', 'Guadalupe Rios', 'lupibeltrame2@gmail.com', NULL, 'AR', 'Reto 15D', 37.95, 'USD', 'active', '2025-09-11T20:39:54'),
  ('RETO15D-caro.savet@gmail.com', 'PURCHASE_COMPLETE', 'Carolina Romero', 'caro.savet@gmail.com', '573105600801', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-15T14:44:20'),
  ('RETO15D-jonatan.traderfx@gmail.com', 'PURCHASE_COMPLETE', 'Jonatan londoño serna', 'jonatan.traderfx@gmail.com', '573242825045', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-17T05:32:34'),
  ('RETO15D-mariamlopezmedina@gmail.com', 'PURCHASE_COMPLETE', 'Marian lopez', 'mariamlopezmedina@gmail.com', '573227685901', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-19T07:48:54'),
  ('RETO15D-admonproteccionymas@gmail.com', 'PURCHASE_COMPLETE', 'Claudia Naranjo', 'admonproteccionymas@gmail.com', '573116136016', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-20T15:51:02'),
  ('RETO15D-edward_27_05@hotmail.com', 'PURCHASE_COMPLETE', 'Edward Orlando Celinz Carreño', 'edward_27_05@hotmail.com', '573102510381', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-21T08:24:00'),
  ('RETO15D-mysmartlifeco@gmail.com', 'PURCHASE_COMPLETE', 'Ana Gomez Miranda', 'mysmartlifeco@gmail.com', '573105056637', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-21T17:01:45'),
  ('RETO15D-camarasenfoquearmenia@gmail.com', 'PURCHASE_COMPLETE', 'JESSYCA ALEJANDRA MORENO GOMEZ', 'camarasenfoquearmenia@gmail.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-25T12:55:10'),
  ('RETO15D-yersonsantoskaizen@gmail.com', 'PURCHASE_COMPLETE', 'Yerson santos', 'yersonsantoskaizen@gmail.com', NULL, 'PE', 'Reto 15D', 36.74, 'USD', 'active', '2025-09-26T01:06:23'),
  ('RETO15D-nadiamulerogordillo@gmail.com', 'PURCHASE_COMPLETE', 'Nadia Mulero Gordillo', 'nadiamulerogordillo@gmail.com', '34610054967', 'ES', 'Reto 15D', 36.97, 'USD', 'active', '2025-09-26T04:00:27'),
  ('RETO15D-gerencia@fotoalegria.com.co', 'PURCHASE_COMPLETE', 'Jose David Betancur Patiño', 'gerencia@fotoalegria.com.co', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-26T06:27:31'),
  ('RETO15D-andersoncruzdigital@gmail.com', 'PURCHASE_COMPLETE', 'Anderson Cruz', 'andersoncruzdigital@gmail.com', '51971882247', 'PE', 'Reto 15D', 36.58, 'USD', 'active', '2025-09-27T09:54:20'),
  ('RETO15D-nel_and@hotmail.com', 'PURCHASE_COMPLETE', 'Nelson Andres Marquez', 'nel_and@hotmail.com', '573012831960', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-27T23:15:29'),
  ('RETO15D-jsanta82@hotmail.com', 'PURCHASE_COMPLETE', 'Juan Manuel Santa monsalve', 'jsanta82@hotmail.com', '573156398490', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-28T12:57:10'),
  ('RETO15D-estebanmejia.sdvsf@gmail.com', 'PURCHASE_COMPLETE', 'Juan Esteban', 'estebanmejia.sdvsf@gmail.com', '573245851651', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-28T20:43:48'),
  ('RETO15D-camilacr.12@hotmail.com', 'PURCHASE_COMPLETE', 'Maria Camila Calle', 'camilacr.12@hotmail.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-29T12:53:53'),
  ('RETO15D-sandraarbelaeztoro@gmail.com', 'PURCHASE_COMPLETE', 'Sandra Elizabeth Arbelaez Toro', 'sandraarbelaeztoro@gmail.com', '573113288946', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-30T06:17:40'),
  ('RETO15D-sebasguerrero12@outlook.com', 'PURCHASE_COMPLETE', 'Daniel Guerrero', 'sebasguerrero12@outlook.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-30T08:05:54'),
  ('RETO15D-geovanni.castano@gmail.com', 'PURCHASE_COMPLETE', 'Geovanni Castaño González', 'geovanni.castano@gmail.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-09-30T10:21:30'),
  ('RETO15D-edwinneduardoreina@gmail.com', 'PURCHASE_COMPLETE', 'Edwin Reina', 'edwinneduardoreina@gmail.com', '573132835396', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-10-01T07:15:16'),
  ('RETO15D-valentina990807@hotmail.com', 'PURCHASE_COMPLETE', 'Angie alvarez', 'valentina990807@hotmail.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-10-04T08:42:16'),
  ('RETO15D-damarisnailsexpert@gmail.com', 'PURCHASE_COMPLETE', 'Damaris Damaris', 'damarisnailsexpert@gmail.com', '573228559782', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-10-05T06:56:24'),
  ('RETO15D-sofiapinzonramirez16@gmail.com', 'PURCHASE_COMPLETE', 'Sofia pinzon', 'sofiapinzonramirez16@gmail.com', '573144780028', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-10-05T10:09:06'),
  ('RETO15D-kserna353@gmail.com', 'PURCHASE_COMPLETE', 'María Katerine Serna Gómez', 'kserna353@gmail.com', '573204541986', 'CO', 'Reto 15D', 20.90, 'USD', 'active', '2025-10-08T13:28:22'),
  ('RETO15D-miguegranadav@gmail.com', 'PURCHASE_COMPLETE', 'Miguel Angel Vasquez Granada', 'miguegranadav@gmail.com', NULL, 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-10-08T17:35:49'),
  ('RETO15D-bblandia17@gmail.com', 'PURCHASE_COMPLETE', 'karla gabriela pascual cruz', 'bblandia17@gmail.com', '50251898949', 'GT', 'Reto 15D', 36.70, 'USD', 'active', '2025-10-08T22:38:24'),
  ('RETO15D-amastali2@gmail.com', 'PURCHASE_COMPLETE', 'Ana mejia', 'amastali2@gmail.com', '573007852691', 'CO', 'Reto 15D', 0.37, 'USD', 'active', '2025-10-14T12:15:25'),
  ('RETO15D-maleja2089@hotmail.com', 'PURCHASE_COMPLETE', 'Alejandra alvarez', 'maleja2089@hotmail.com', '573185540094', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-10-15T11:42:29'),
  ('RETO15D-rmmagia@gmail.com', 'PURCHASE_COMPLETE', 'Ricardo Montoya', 'rmmagia@gmail.com', '573502448421', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-11-08T22:15:41'),
  ('RETO15D-monicamariagomez78@gmail.com', 'PURCHASE_COMPLETE', 'Mónica María Gómez Hernández', 'monicamariagomez78@gmail.com', '573023837564', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-12-27T11:54:46'),
  ('RETO15D-sebastianmcsa77@gmail.com', 'PURCHASE_COMPLETE', 'Sebastian Montoya Correa', 'sebastianmcsa77@gmail.com', '573146705089', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2025-12-27T15:43:03'),
  ('RETO15D-s.caicedo.ocampo@gmail.com', 'PURCHASE_COMPLETE', 'Sebastián Caicedo Ocampo', 's.caicedo.ocampo@gmail.com', '573167506142', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2026-01-01T13:46:39'),
  ('RETO15D-marcela0205@hotmail.com', 'PURCHASE_COMPLETE', 'Diana Marcela Duque Garcia', 'marcela0205@hotmail.com', '573126244032', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2026-01-01T21:20:59'),
  ('RETO15D-jvuc12@hotmail.com', 'PURCHASE_COMPLETE', 'jovanny usuga', 'jvuc12@hotmail.com', '573216073746', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2026-01-03T23:45:36'),
  ('RETO15D-chispaandina@gmail.com', 'PURCHASE_COMPLETE', 'Dariela Nina Medina', 'chispaandina@gmail.com', '51945755057', 'PE', 'Reto 15D', 36.57, 'USD', 'active', '2026-01-04T20:38:55'),
  ('RETO15D-conbar74@gmail.com', 'PURCHASE_COMPLETE', 'Libia Constanza Barbosa Galvis', 'conbar74@gmail.com', '573246822478', 'CO', 'Reto 15D', 36.57, 'USD', 'active', '2026-01-05T21:27:37')
ON CONFLICT (hotmart_id) DO UPDATE SET
  buyer_phone   = COALESCE(EXCLUDED.buyer_phone,   transactions.buyer_phone),
  buyer_country = COALESCE(EXCLUDED.buyer_country, transactions.buyer_country),
  buyer_name    = COALESCE(EXCLUDED.buyer_name,    transactions.buyer_name);

-- PASO 2: Insertar / actualizar suscripciones Reto 15D
INSERT INTO subscriptions
  (subscriber_code, buyer_email, buyer_name, plan_name, status, amount, currency, updated_at)
VALUES
  ('RETO15D-crogutierrez@gmail.com', 'crogutierrez@gmail.com', 'Carmenrosa Gutierrez Pinedo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mariamildreyzuluaga@icloud.com', 'mariamildreyzuluaga@icloud.com', 'Mildrey Zuluaga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-linaavilez@hotmail.com', 'linaavilez@hotmail.com', 'Emelina Maria Avilez Diaz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juanda125@hotmail.com', 'juanda125@hotmail.com', 'juan david bustamante montoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-greycmarseminario@gmail.com', 'greycmarseminario@gmail.com', 'Greycmar seminario', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alejandra.fernandez.redes@gmail.com', 'alejandra.fernandez.redes@gmail.com', 'Alejandra Fernandez andrade', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jacar170@hotmail.com', 'jacar170@hotmail.com', 'Jair Díaz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angeldie8383@gmail.com', 'angeldie8383@gmail.com', 'Angélica María castaño Piedrahíta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresjbd94@gmail.com', 'andresjbd94@gmail.com', 'Andrés Jeussepe Blanco Durango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mcgmaryluz@gmail.com', 'mcgmaryluz@gmail.com', 'Mary Luz Campos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nelsonramirezc2@gmail.com', 'nelsonramirezc2@gmail.com', 'Humberto Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lutraveling.agencia@gmail.com', 'lutraveling.agencia@gmail.com', 'JHON FREDDY MORENO COPETE', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-tatianagarcia2616@gmail.com', 'tatianagarcia2616@gmail.com', 'Tatiana García Castañeda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dahiana.cortes.toro@gmail.com', 'dahiana.cortes.toro@gmail.com', 'Dahiana cortes', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-milagrosmjvr@hotmail.com', 'milagrosmjvr@hotmail.com', 'Milagros Villa', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-msmargaritasarmiento@gmail.com', 'msmargaritasarmiento@gmail.com', 'Margarita Sarmiento', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mariamejuto1708@gmail.com', 'mariamejuto1708@gmail.com', 'Maria Mejuto', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mailynok@hotmail.com', 'mailynok@hotmail.com', 'Maylin De Zubiria Grandett', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dcortesph@gmail.com', 'dcortesph@gmail.com', 'Daniela Cortes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jarojas.hernandez@gmail.com', 'jarojas.hernandez@gmail.com', 'Jorge Andrés Rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gustaavochaavez@gmail.com', 'gustaavochaavez@gmail.com', 'Gustavo Chavez Conde', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juancarlos.ecommerce@gmail.com', 'juancarlos.ecommerce@gmail.com', 'Juan Caro Carlos Caro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kattyhealthcoach@gmail.com', 'kattyhealthcoach@gmail.com', 'Katiuska Bonilla', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-agrimensurafondeur@hotmail.com', 'agrimensurafondeur@hotmail.com', 'Leinizt Fondeur', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-lujanperezgeraldine@gmail.com', 'lujanperezgeraldine@gmail.com', 'Santiago Tapias', 'Reto 15D', 'active', 0.37, 'USD', NOW()),
  ('RETO15D-caceres-itpro@outlook.com', 'caceres-itpro@outlook.com', 'Diego Cáceres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-davidramirezpersonal@gmail.com', 'davidramirezpersonal@gmail.com', 'David Ramirez Juarez', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-hectorzamudio183@gmail.com', 'hectorzamudio183@gmail.com', 'Héctor osnaider Zamudio Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yyaqueline06@gmail.com', 'yyaqueline06@gmail.com', 'Yaqueline Otavo villamil', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-valeriaruiz_24@hotmail.com', 'valeriaruiz_24@hotmail.com', 'Valeria Ruiz', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-ximetello33@gmail.com', 'ximetello33@gmail.com', 'Ximena Tello', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jaramillovelasquezlaura@gmail.com', 'jaramillovelasquezlaura@gmail.com', 'Laura Jaramillo', 'Reto 15D', 'active', 37.12, 'USD', NOW()),
  ('RETO15D-tessitore1975@hotmail.com', 'tessitore1975@hotmail.com', 'Fausto Eladio Tejedor Ramon', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-luisaechava@hotmail.com', 'luisaechava@hotmail.com', 'Luisa Echavarria', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-julianmv@hotmail.com', 'julianmv@hotmail.com', 'Julian Moreno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johncanoocasal@gmail.com', 'johncanoocasal@gmail.com', 'JOHN CANO OCASAL', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johanescuello27@gmail.com', 'johanescuello27@gmail.com', 'Johanes Cuello', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vd944@hotmail.com', 'vd944@hotmail.com', 'Vanessa Diaz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-stalinbravo55@gmail.com', 'stalinbravo55@gmail.com', 'Stalin Bravo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angelicasedi@hotmail.com', 'angelicasedi@hotmail.com', 'Maria Sendoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-necha119@hotmail.com', 'necha119@hotmail.com', 'Vanessa cantarero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pinedaneyrakatheleenbrissette@gmail.com', 'pinedaneyrakatheleenbrissette@gmail.com', 'Katheleen Pineda', 'Reto 15D', 'active', 35.71, 'USD', NOW()),
  ('RETO15D-raffocorantes@gmail.com', 'raffocorantes@gmail.com', 'RAFAEL ALONZO CORANTES SANCHEZ NINA', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-frank.valverde89@gmail.com', 'frank.valverde89@gmail.com', 'Frank Nicols Valverde', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rony51087@gmail.com', 'rony51087@gmail.com', 'Rony Campos', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-gvcapitalinvestment@gmail.com', 'gvcapitalinvestment@gmail.com', 'Ignacio Villasenor', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-nataliajg1997@gmail.com', 'nataliajg1997@gmail.com', 'Natalia Jiménez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jmunevcla@live.com', 'jmunevcla@live.com', 'Javier David Munevar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leidycordoba@gmail.com', 'leidycordoba@gmail.com', 'Leidy Johanna Córdoba Acevedo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-catalinaalzate0@gmail.com', 'catalinaalzate0@gmail.com', 'Catalina Alzate', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-miguelferu@gmail.com', 'miguelferu@gmail.com', 'Miguel Urquijo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danilozcr@gmail.com', 'danilozcr@gmail.com', 'Danilo Zamora', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marce_corredor@hotmail.com', 'marce_corredor@hotmail.com', 'Ana marcela corredor', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresbel84@hotmail.com', 'andresbel84@hotmail.com', 'Andrés mauricio Beltrán Hernández', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carolina.carmona2@udea.edu.co', 'carolina.carmona2@udea.edu.co', 'carolina carmona henao', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lilimofl@hotmail.com', 'lilimofl@hotmail.com', 'Liliana Maria Montoya Florez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-liz@poleta.co', 'liz@poleta.co', 'Lizeth Galvis', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-paulitamonsalve@hotmail.com', 'paulitamonsalve@hotmail.com', 'Paula Monsalve', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mabel.olivares2707@gmail.com', 'mabel.olivares2707@gmail.com', 'Mabel Olivares', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-richi120901@gmail.com', 'richi120901@gmail.com', 'Ricardo hernandez reyes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-guifoshamburguesas@gmail.com', 'guifoshamburguesas@gmail.com', 'Santiago Guido Duque', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vicodila.19@gmail.com', 'vicodila.19@gmail.com', 'sandra lizeth victoria diaz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diegomonroy696@gmail.com', 'diegomonroy696@gmail.com', 'Diego Felipe Shwkyng Monroy', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-steven.moreno155@gmail.com', 'steven.moreno155@gmail.com', 'Steven Moreno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-edwin050498@gmail.com', 'edwin050498@gmail.com', 'Edwin Cañas Largo', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-johannabanoveliz@gmail.com', 'johannabanoveliz@gmail.com', 'Emilyn Bano', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-maujr.94@gmail.com', 'maujr.94@gmail.com', 'Jesús Armando llanos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-geraldyne2112@gmail.com', 'geraldyne2112@gmail.com', 'Geraldyne Rios', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-proyectosgrowth@gmail.com', 'proyectosgrowth@gmail.com', 'Álvaro Bermúdez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yurymat@hotmail.com', 'yurymat@hotmail.com', 'YURY ANDREA MARTINEZ MEDINA', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-inverstru@gmail.com', 'inverstru@gmail.com', 'Daniel Muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juliovillarreal84@hotmail.com', 'juliovillarreal84@hotmail.com', 'Julio César Villarreal González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-naranjoboteros@gmail.com', 'naranjoboteros@gmail.com', 'Sebastian Naranjo Botero', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-penamata90@gmail.com', 'penamata90@gmail.com', 'Miguel Angel Peña Mata', 'Reto 15D', 'active', 37.38, 'USD', NOW()),
  ('RETO15D-mariav0531@hotmail.com', 'mariav0531@hotmail.com', 'Maria Victoria Millan', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-muneramichel@outlook.es', 'muneramichel@outlook.es', 'Michell munera', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-mauriciodiazrealtor@gmail.com', 'mauriciodiazrealtor@gmail.com', 'Mauricio Díaz González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juliperu@gmail.com', 'juliperu@gmail.com', 'Juliana Pérez Ruiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-natalia88saldana@gmail.com', 'natalia88saldana@gmail.com', 'Lorena Saldaña', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejandra-626@hotmail.com', 'alejandra-626@hotmail.com', 'Diana hoyos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-monik25891@hotmail.com', 'monik25891@hotmail.com', 'Mónica carolina Trejo marin', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-edison.patron.sabando@gmail.com', 'edison.patron.sabando@gmail.com', 'Edison Patron', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-erlymplaceres10@gmail.com', 'erlymplaceres10@gmail.com', 'Erlym Placeres', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mb4marketingagency@gmail.com', 'mb4marketingagency@gmail.com', 'sergio rincon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vargasalvaradotatiana@gmail.com', 'vargasalvaradotatiana@gmail.com', 'Tatiana Vargas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-natalia881201@hotmail.com', 'natalia881201@hotmail.com', 'Natalia Calderón Calderón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rafael.och8a@gmail.com', 'rafael.och8a@gmail.com', 'Rafael Ignacio Ochoa Ochoa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fliaog65@gmail.com', 'fliaog65@gmail.com', 'Juan Camilo Oñate Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-richardace2023@gmail.com', 'richardace2023@gmail.com', 'Ricardo Acevedo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luisis012664@gmail.com', 'luisis012664@gmail.com', 'Luisa Aristizabal', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-creamostuestilo.empaquetados@gmail.com', 'creamostuestilo.empaquetados@gmail.com', 'Wendy Vanessa Castañeda Negrete', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-suarezstev1@gmail.com', 'suarezstev1@gmail.com', 'Steven Suarez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-heidyjo.loa@gmail.com', 'heidyjo.loa@gmail.com', 'Heidy Yohana Cabezas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-juan.chicaiza.og@gmail.com', 'juan.chicaiza.og@gmail.com', 'Juan Chicaiza', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mngomezc09@gmail.com', 'mngomezc09@gmail.com', 'Mabel Gómez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-everisieri@gmail.com', 'everisieri@gmail.com', 'Ever Risieri Irala Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-erikameneses0128@gmail.com', 'erikameneses0128@gmail.com', 'Erika Meneses', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jhonbrandon504@gmail.com', 'jhonbrandon504@gmail.com', 'Jhon brandon florez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cristian.camarin@gmail.com', 'cristian.camarin@gmail.com', 'Cristian Camilo Marin Acosta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carolina.ramos.em@gmail.com', 'carolina.ramos.em@gmail.com', 'Carolina Ramos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hapedraza1@gmail.com', 'hapedraza1@gmail.com', 'Hector Pedraza', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jclo888@hotmail.com', 'jclo888@hotmail.com', 'Jenny Logaña', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-aguamarinafashion@gmail.com', 'aguamarinafashion@gmail.com', 'Jenny Florez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karenisa14@gmail.com', 'karenisa14@gmail.com', 'Karen oviedo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jeiale0429@hotmail.com', 'jeiale0429@hotmail.com', 'Jeidy Alexandra Saray Abello', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-brayanaguilarsas@gmail.com', 'brayanaguilarsas@gmail.com', 'Brayan Aguilar', 'Reto 15D', 'active', 0.37, 'USD', NOW()),
  ('RETO15D-juanfraglez@gmail.com', 'juanfraglez@gmail.com', 'ALTERNATIVAS Y PROCESOS DE PARTICIPACION SOCIAL', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sofimartinez4994@hotmail.com', 'sofimartinez4994@hotmail.com', 'Gloria Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-estefinarvaez-07@hotmail.com', 'estefinarvaez-07@hotmail.com', 'Estefanny Narvaez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angus23sms@gmail.com', 'angus23sms@gmail.com', 'Sergio Sanguino', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-valeriagonzales071024@gmail.com', 'valeriagonzales071024@gmail.com', 'Valeria González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-eileennrodriguez@gmail.com', 'eileennrodriguez@gmail.com', 'Eileen Rodríguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-susanaarambulam@gmail.com', 'susanaarambulam@gmail.com', 'Susana arambula miñarro', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-businessbynatacatano@gmail.com', 'businessbynatacatano@gmail.com', 'natalia cataño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejoravec@gmail.com', 'alejoravec@gmail.com', 'Didier Alejandro Rave Castillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vvu920618@gmail.com', 'vvu920618@gmail.com', 'Vanessa V', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-silvanah2479@gmail.com', 'silvanah2479@gmail.com', 'Astrid Silvana Hoyos Gomez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gonzalezd@ut.edu.co', 'gonzalezd@ut.edu.co', 'Daniela González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nicolasmillan0532@gmail.com', 'nicolasmillan0532@gmail.com', 'Nicolas Becerra Millán', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-arufino692@gmail.com', 'arufino692@gmail.com', 'Alberto Rufino', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ogomez0396@gmail.com', 'ogomez0396@gmail.com', 'Oscar Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-geraldineandradep1019@gmail.com', 'geraldineandradep1019@gmail.com', 'Geraldine Andrade pantoja', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-violetapaos@hotmail.com', 'violetapaos@hotmail.com', 'Paola Andrea Arias García', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lauralvargast@gmail.com', 'lauralvargast@gmail.com', 'laura liceth vargas triana', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-kellintube@gmail.com', 'kellintube@gmail.com', 'Kellin Yurani Tuberquia Betancur', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-valw09010@gmail.com', 'valw09010@gmail.com', 'Lwendy Valeria Calderon Escalante', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-stevmachado07@gmail.com', 'stevmachado07@gmail.com', 'Steven Ebrain Romich Machado Lozada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-eduardogabriell2004@gmail.com', 'eduardogabriell2004@gmail.com', 'Gabriel Eduardo Blanco Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mabracho@gmail.com', 'mabracho@gmail.com', 'Maria Bracho', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-santiagolopezm93@gmail.com', 'santiagolopezm93@gmail.com', 'Santiago Lopez Martinez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-leydy.plataa@gmail.com', 'leydy.plataa@gmail.com', 'Leydy Jhoayra Plata Céspedes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lauragomez5413@gmail.com', 'lauragomez5413@gmail.com', 'Laura Gomez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-tatiana.palaciosplazas@gmail.com', 'tatiana.palaciosplazas@gmail.com', 'Yuly Tatiana Palacios Plazas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-karvalencia@gmail.com', 'karvalencia@gmail.com', 'Karen valencia diaz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresmoriones1909@gmail.com', 'andresmoriones1909@gmail.com', 'Andres moriones', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karenposadazapata@gmail.com', 'karenposadazapata@gmail.com', 'Karen Posada Zapata', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-julian.vascocalle2@gmail.com', 'julian.vascocalle2@gmail.com', 'julian Vasco Calle', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-claudiahappy74@gmail.com', 'claudiahappy74@gmail.com', 'Claudia Portilla', 'Reto 15D', 'active', 35.96, 'USD', NOW()),
  ('RETO15D-paulaquintero2024@gmail.com', 'paulaquintero2024@gmail.com', 'Paula cespedes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maristi1210@gmail.com', 'maristi1210@gmail.com', 'Manuel Aristizabal', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-megabella2020@gmail.com', 'megabella2020@gmail.com', 'Jose Luis Calderon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresrcamargo@gmail.com', 'andresrcamargo@gmail.com', 'Andres Rueda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-firstclassbeautybar1@gmail.com', 'firstclassbeautybar1@gmail.com', 'Maggie Lopez Lopez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-netjahlive@hotmail.com', 'netjahlive@hotmail.com', 'Janet Franco', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-danielreyes2904@gmail.com', 'danielreyes2904@gmail.com', 'Daniel Fabian Reyes Neira', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-smosquera23@hotmail.com', 'smosquera23@hotmail.com', 'Wendy Mosquera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jsernaz1990@gmail.com', 'jsernaz1990@gmail.com', 'Jorge Serna zapata', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-smoralescarrasquilla@gmail.com', 'smoralescarrasquilla@gmail.com', 'Sebastián morales carrasquilla', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-montoyajuliana7@gmail.com', 'montoyajuliana7@gmail.com', 'Juliana tejada montoya', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-crisacar81@gmail.com', 'crisacar81@gmail.com', 'Crispin Ariel Cartagena Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hbce09@gmail.com', 'hbce09@gmail.com', 'HUMBERTO BERNARD CESAR ESPITIA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juancamilomunoz16@gmail.com', 'juancamilomunoz16@gmail.com', 'Juan Munoz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-eco.carlosvalencia7@gmail.com', 'eco.carlosvalencia7@gmail.com', 'Carlos Valencia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luizingonzalez@hotmail.com', 'luizingonzalez@hotmail.com', 'Luis gonzalez mendez', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-chaconclau@gmail.com', 'chaconclau@gmail.com', 'Claudia Chacón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-robingamez11usa@gmail.com', 'robingamez11usa@gmail.com', 'Robinson Gamez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ruisusan1@gmail.com', 'ruisusan1@gmail.com', 'Luis Salazar', 'Reto 15D', 'active', 36.39, 'USD', NOW()),
  ('RETO15D-juanita.lc46@gmail.com', 'juanita.lc46@gmail.com', 'Juanita Londoño Cardona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-claudiacv733@gmail.com', 'claudiacv733@gmail.com', 'Claudia Castano', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-marcela96pereira@hotmail.com', 'marcela96pereira@hotmail.com', 'Robinson Pereira', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-stephanny.oberto@gmail.com', 'stephanny.oberto@gmail.com', 'Stephanny Alejandra Oberto', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mjandresorozco@gmail.com', 'mjandresorozco@gmail.com', 'Andres orozco', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juliethlopezmentora@gmail.com', 'juliethlopezmentora@gmail.com', 'Julieth Lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-simonhurtado37@gmail.com', 'simonhurtado37@gmail.com', 'Simon Hurtado Betancur', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jahircarrillo60@gmail.com', 'jahircarrillo60@gmail.com', 'Alex Carrillo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-amalfyh_74@hotmail.com', 'amalfyh_74@hotmail.com', 'Amalfy Arce Medina', 'Reto 15D', 'active', 35.56, 'USD', NOW()),
  ('RETO15D-santipatino3@gmail.com', 'santipatino3@gmail.com', 'Santiago Patiño Bustamante', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-waffleticali@gmail.com', 'waffleticali@gmail.com', 'Saira Ospina', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-avilaagustin299@gmail.com', 'avilaagustin299@gmail.com', 'Agustín Ávila', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-valeriamazo37@gmail.com', 'valeriamazo37@gmail.com', 'Valeria Zuleta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresarias1128@gmail.com', 'andresarias1128@gmail.com', 'Andres Felipe Arias Posada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nagb77@gmail.com', 'nagb77@gmail.com', 'Nina Gutierrez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-h.patricia.pena@gmail.com', 'h.patricia.pena@gmail.com', 'Henny Patricia Peña M', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yannadelvalle@gmail.com', 'yannadelvalle@gmail.com', 'Yanna del Valle', 'Reto 15D', 'active', 37.13, 'USD', NOW()),
  ('RETO15D-riverosstiven06@gmail.com', 'riverosstiven06@gmail.com', 'JORGE STIVEN RIVEROS ESPEJO', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jennifergiraldo2011@gmail.com', 'jennifergiraldo2011@gmail.com', 'Jennifer Giraldo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ferrolon37@gmail.com', 'ferrolon37@gmail.com', 'Fernando Rolón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angelo_ramirez1204@hotmail.com', 'angelo_ramirez1204@hotmail.com', 'Angelo Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marketing.13kk@gmail.com', 'marketing.13kk@gmail.com', 'Camilo Garzon O', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-didiergalindo20@gmail.com', 'didiergalindo20@gmail.com', 'didier berrio galindo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gladyssantizo4@gmail.com', 'gladyssantizo4@gmail.com', 'Gladys Santizo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jenny.paola.acosta94@gmail.com', 'jenny.paola.acosta94@gmail.com', 'Jenny Paola Acosta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-info@ecologictravel.com.ar', 'info@ecologictravel.com.ar', 'Marcelo Javier Perucchi', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-carloshidalgo.dvs@icloud.com', 'carloshidalgo.dvs@icloud.com', 'Carlos Hidalgo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-sandrasalas16@icloud.com', 'sandrasalas16@icloud.com', 'Sandra salas alvarez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ppsalo24@gmail.com', 'ppsalo24@gmail.com', 'Pablo Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leisan85@hotmail.com', 'leisan85@hotmail.com', 'Leydy sanchez henao', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-contacto@dseo.cl', 'contacto@dseo.cl', 'Joseph Cuevas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-rosis2554@gmail.com', 'rosis2554@gmail.com', 'Rosa Morales', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alexandervelez65@gmail.com', 'alexandervelez65@gmail.com', 'Alexander Madrid', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-stefanyuliethernandez@gmail.com', 'stefanyuliethernandez@gmail.com', 'Stefany Hernandez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-m1atdianabedoya@gmail.com', 'm1atdianabedoya@gmail.com', 'Diana Bedoya Bedoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-julianramirezv@me.com', 'julianramirezv@me.com', 'Julian Ramirez Velez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mharboleda@gmail.com', 'mharboleda@gmail.com', 'Maria Helena Arboleda D', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-santiagotapiasc+reto@gmail.com', 'santiagotapiasc+reto@gmail.com', 'Santiago Tapias', 'Reto 15D', 'active', 0.37, 'USD', NOW()),
  ('RETO15D-jtrujillobetancur+reto@gmail.com', 'jtrujillobetancur+reto@gmail.com', 'Jhei Trujillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-creativetiendacol@gmail.com', 'creativetiendacol@gmail.com', 'Katerine Tocancipa Gutierrez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ktgonzalezp9027@gmail.com', 'ktgonzalezp9027@gmail.com', 'katerine gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-truebarbersmx@gmail.com', 'truebarbersmx@gmail.com', 'Gerson Sandoval Esparza', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-estefania.garcia1400@gmail.com', 'estefania.garcia1400@gmail.com', 'Estefania Garcia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-paomazo@gmail.com', 'paomazo@gmail.com', 'Paola mazo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ladoctoracerebro@gmail.com', 'ladoctoracerebro@gmail.com', 'Pilar Fierro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-moniacpa@gmail.com', 'moniacpa@gmail.com', 'Mónica Acosta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-msanchezc97@gmail.com', 'msanchezc97@gmail.com', 'Martin Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carlosavendano@hotmail.com', 'carlosavendano@hotmail.com', 'Carlos avendano', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-daniel.outdoor.96@gmail.com', 'daniel.outdoor.96@gmail.com', 'Juan Daniel Lopez Posada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juliana@investopi.com', 'juliana@investopi.com', 'Juliana matiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marcelarodriguezcaro@yahoo.com', 'marcelarodriguezcaro@yahoo.com', 'Diana Marcela Rodríguez Caro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-loreg97personal@gmail.com', 'loreg97personal@gmail.com', 'Lorena Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dmoyaarevalo78@gmail.com', 'dmoyaarevalo78@gmail.com', 'Diana Moya', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-aafragozo@gmail.com', 'aafragozo@gmail.com', 'Ana Angel Fragozo Britto', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ingvhcamargo@hotmail.com', 'ingvhcamargo@hotmail.com', 'Victor h Camargo s', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-anviju0220@gmail.com', 'anviju0220@gmail.com', 'Angie Viviana Figueroa Farfan', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mauriciogiraldo7877@politecnicomayor.edu.co', 'mauriciogiraldo7877@politecnicomayor.edu.co', 'Mauricio Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dannae_martinez@hotmail.com', 'dannae_martinez@hotmail.com', 'CLAUDIA MARTINEZ', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-eliana0627gomez@gmail.com', 'eliana0627gomez@gmail.com', 'Eliana Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jenny.r8@hotmail.com', 'jenny.r8@hotmail.com', 'Yenny palla roa', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-fa503636@gmail.com', 'fa503636@gmail.com', 'Franco Alvarado', 'Reto 15D', 'active', 37.16, 'USD', NOW()),
  ('RETO15D-quicenoandrea87@gmail.com', 'quicenoandrea87@gmail.com', 'Andrea Quiceno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-astridbedoya24@gmsil.com', 'astridbedoya24@gmsil.com', 'Astrid Bedoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-samuelfelpa@gmail.com', 'samuelfelpa@gmail.com', 'Samuel perez patiño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-margaritacastillolaviada@gmail.com', 'margaritacastillolaviada@gmail.com', 'Margarita castillo', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-yormarymontesg@gmail.com', 'yormarymontesg@gmail.com', 'Yor Mary Montes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jgarnicajimenez@gmail.com', 'jgarnicajimenez@gmail.com', 'Julian Garnica', 'Reto 15D', 'active', 36.82, 'USD', NOW()),
  ('RETO15D-yisnesuarez02@gmail.com', 'yisnesuarez02@gmail.com', 'Yisney suarez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alejandra.sape@gmail.com', 'alejandra.sape@gmail.com', 'Alejandra Salazar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-genera.propiedades.mx@gmail.com', 'genera.propiedades.mx@gmail.com', 'jessica pineda', 'Reto 15D', 'active', 36.95, 'USD', NOW()),
  ('RETO15D-cdagudelo94@gmail.com', 'cdagudelo94@gmail.com', 'Cesar David Agudelo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johanalizgomez@gmail.com', 'johanalizgomez@gmail.com', 'Johana Gomez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-eliana.gomezmunoz@gmail.com', 'eliana.gomezmunoz@gmail.com', 'Eliana Gómez Muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-aureliaquinonez@gmail.com', 'aureliaquinonez@gmail.com', 'Aurelia Quiñonez Quiñonez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ingclaudiazuluaga@gmail.com', 'ingclaudiazuluaga@gmail.com', 'Claudia Maria Zuluaga Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-eleramosbe@gmail.com', 'eleramosbe@gmail.com', 'Maria Elena Ramos Berrocal', 'Reto 15D', 'active', 35.58, 'USD', NOW()),
  ('RETO15D-davidrom9905@gmail.com', 'davidrom9905@gmail.com', 'David Romala', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cabran112@gmail.com', 'cabran112@gmail.com', 'Cristian Bran', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leidyjquintanilla@gmail.com', 'leidyjquintanilla@gmail.com', 'Leidy Quintanilla', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-miguelfranco94@hotmail.com', 'miguelfranco94@hotmail.com', 'Miguel Andres Franco Arango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bocanegranogueraangie@gmail.com', 'bocanegranogueraangie@gmail.com', 'Angie Bocanegra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karla.cgommez32@gmail.com', 'karla.cgommez32@gmail.com', 'Karla Gomez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-vividuran2015@gmail.com', 'vividuran2015@gmail.com', 'Viviana duran', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-katherine.cortess1@gmail.com', 'katherine.cortess1@gmail.com', 'Katherine cortes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danielcorrealopez11@gmail.com', 'danielcorrealopez11@gmail.com', 'Daniel Correa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-castillomaria911005@gmail.com', 'castillomaria911005@gmail.com', 'María castillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dianaraquelpenar@gmail.com', 'dianaraquelpenar@gmail.com', 'Diana Raquel Peña Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-davidpe30@outlook.com', 'davidpe30@outlook.com', 'David pena duenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nini-jhova@hotmail.com', 'nini-jhova@hotmail.com', 'johana narvaez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cruzheidy58@gmail.com', 'cruzheidy58@gmail.com', 'Heidy Cruz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cablanpa@gmail.com', 'cablanpa@gmail.com', 'Carlos Blanco', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jgvroach19@outlook.com', 'jgvroach19@outlook.com', 'Jonathan Gonzalez Vallejo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yessikap9301@gmail.com', 'yessikap9301@gmail.com', 'Yessica paola Mendoza Aguilar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-judaniel16@gmail.com', 'judaniel16@gmail.com', 'Juan Daniel Marin Galvis', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-zayratriana@hotmail.com', 'zayratriana@hotmail.com', 'ZAYRA XIMENA TRIANA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-felipe25733@gmail.com', 'felipe25733@gmail.com', 'Andres Suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cmelannyb@gmail.com', 'cmelannyb@gmail.com', 'Melanny Paola Cervantes Bermúdez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-samluis292@gmail.com', 'samluis292@gmail.com', 'Luis Evelio García Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marito8601@hotmail.com', 'marito8601@hotmail.com', 'Mario Chaparro', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-ingsheilabelandria@gmail.com', 'ingsheilabelandria@gmail.com', 'Sheila Belandria Belandria', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-valenmuch70@gmail.com', 'valenmuch70@gmail.com', 'valentina gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danielaortizb7@gmail.com', 'danielaortizb7@gmail.com', 'Daniela Ortiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-claudiagiselle84@gmail.com', 'claudiagiselle84@gmail.com', 'Claudia Benavides', 'Reto 15D', 'active', 37.22, 'USD', NOW()),
  ('RETO15D-juanabenavides0815@gmail.com', 'juanabenavides0815@gmail.com', 'Juana Benavides', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-gustavovasquez.1624@gmail.com', 'gustavovasquez.1624@gmail.com', 'Gustavo Adolfo Vasquez Hernández', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-isaromero2021@gmail.com', 'isaromero2021@gmail.com', 'Isabel romero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bymayelaroman@gmail.com', 'bymayelaroman@gmail.com', 'Mayela Roman', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jomiva@hotmail.com', 'jomiva@hotmail.com', 'Jose Miguel Vargas', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-jucaloba3@gmail.com', 'jucaloba3@gmail.com', 'Juan Camilo Lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-milenag227@gmail.com', 'milenag227@gmail.com', 'Yadil Milena Galvis Hernández', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vl2683431@gmail.com', 'vl2683431@gmail.com', 'Victor manuel lopez mejia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yurani.v.garcia@gmail.com', 'yurani.v.garcia@gmail.com', 'Yurani Viviana García Alfonso', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jose-ts01@outlook.com', 'jose-ts01@outlook.com', 'José Luis tangarife sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-davidbarpf@hotmail.com', 'davidbarpf@hotmail.com', 'David Barrios Chávez', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-erikanavas24@gmail.com', 'erikanavas24@gmail.com', 'Erika Navas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-cursosgpo@gmail.com', 'cursosgpo@gmail.com', 'Cristian Salgado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mhperez1801@gmail.com', 'mhperez1801@gmail.com', 'Maria helena perez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juli.riveracr@gmail.com', 'juli.riveracr@gmail.com', 'Julieth Rivera', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-francofuentes2@gmail.com', 'francofuentes2@gmail.com', 'Jhon Fredy Franco Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hola@efectogrowth.com', 'hola@efectogrowth.com', 'Oscar Javier Salazar Amaya', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-karenrojasm19@gmail.com', 'karenrojasm19@gmail.com', 'Karen Paola Rojas Mamani', 'Reto 15D', 'active', 37.22, 'USD', NOW()),
  ('RETO15D-gomezserna.paola@gmail.com', 'gomezserna.paola@gmail.com', 'Paola Andrea Gomez Serna', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-felipecurvelo@hotmail.com', 'felipecurvelo@hotmail.com', 'Felipe Curvelo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rosalia_jaol@hotmail.com', 'rosalia_jaol@hotmail.com', 'Rosalia leon', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ginatbaldion@gmail.com', 'ginatbaldion@gmail.com', 'gina paola Triviño Baldion', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jencano18@gmail.com', 'jencano18@gmail.com', 'Jennifer Cano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carloscartagena2405@gmail.com', 'carloscartagena2405@gmail.com', 'Carlos Cartagena', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marce.1524@hotmail.com', 'marce.1524@hotmail.com', 'Leslie Marcela Gomez Cardenas', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-cmurillomurillo92@gmail.com', 'cmurillomurillo92@gmail.com', 'Carlos Daniel Murillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-osanchez9991@gmail.com', 'osanchez9991@gmail.com', 'Omar Sanchez Mondragón', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-juanfmarulanda00@outlook.com', 'juanfmarulanda00@outlook.com', 'Juan Felipe Marulanda Pérez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-astronomo87@gmail.com', 'astronomo87@gmail.com', 'COSMOSHOP SAS', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-adeanahbl@gmail.com', 'adeanahbl@gmail.com', 'Adeana Garcia Paz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lorygil26@gmail.com', 'lorygil26@gmail.com', 'Loren rendon gil', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-wendytamayo@hotmail.com', 'wendytamayo@hotmail.com', 'Wendy Arenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-adsjoserojas@gmail.com', 'adsjoserojas@gmail.com', 'José rojas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ardila.ing@gmail.com', 'ardila.ing@gmail.com', 'Ariel Ardila', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-martinabenal@hotmail.com', 'martinabenal@hotmail.com', 'Martina Alexandra Benalcázar Mena', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-julian09.jl@gmail.com', 'julian09.jl@gmail.com', 'Julian Lozano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-michellemoav@hotmail.com', 'michellemoav@hotmail.com', 'Michelle Molina Avendaño', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-juancamilomosari@gmail.com', 'juancamilomosari@gmail.com', 'Juan Mosquera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gabrimora21@gmail.com', 'gabrimora21@gmail.com', 'Gabriela Mora', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-melyocampo06@hotmail.com', 'melyocampo06@hotmail.com', 'Melissa Ocampo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-somosmarketingam@gmail.com', 'somosmarketingam@gmail.com', 'Alejandra martinez jaramillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-colorclick2014@gmail.com', 'colorclick2014@gmail.com', 'andrea gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-katherin4280@hotmail.com', 'katherin4280@hotmail.com', 'katherin pastor pulgarin', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vaneporti2@gmail.com', 'vaneporti2@gmail.com', 'Vanessa Portilla Correa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-decokidscuadritosconamor@gmail.com', 'decokidscuadritosconamor@gmail.com', 'Nataly monsalve', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sailyscardenasm@hotmail.com', 'sailyscardenasm@hotmail.com', 'Sailys Cardenas mercado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-solutececommerce@gmail.com', 'solutececommerce@gmail.com', 'José Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-solmarianagranadosvargas@gmail.com', 'solmarianagranadosvargas@gmail.com', 'Sol Mariana Granados Vargas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-morenocorreadk@gmail.com', 'morenocorreadk@gmail.com', 'Edilson Fernando Moreno Correa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jpbustamante20@outlook.com', 'jpbustamante20@outlook.com', 'Juan Pablo Bustamante', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-iveenaranjo@gmail.com', 'iveenaranjo@gmail.com', 'Ivonne Naranjo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alexandra_14533669@hotmail.com', 'alexandra_14533669@hotmail.com', 'alexandra gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marcelamacias2016@gmail.com', 'marcelamacias2016@gmail.com', 'Marcela macias', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cliosocialescan@gmail.com', 'cliosocialescan@gmail.com', 'Paty Barón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jhanpineda24@gmail.com', 'jhanpineda24@gmail.com', 'jhan carlos pineda morales', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hernandezyasmely@gmail.com', 'hernandezyasmely@gmail.com', 'Yasmely Hernandez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-daohe16@gmail.com', 'daohe16@gmail.com', 'Daniela Osorio Henao', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-foixcar@gmail.com', 'foixcar@gmail.com', 'Jose Hali', 'Reto 15D', 'active', 38.34, 'USD', NOW()),
  ('RETO15D-melisagiraldo.ai@gmail.com', 'melisagiraldo.ai@gmail.com', 'MELISA GIRALDO', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mennarcompras@hotmail.com', 'mennarcompras@hotmail.com', 'William muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-info@jhonnvesga.com', 'info@jhonnvesga.com', 'Jhonn Vesga', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-virgicordeiro@gmail.com', 'virgicordeiro@gmail.com', 'Virginia Cordeiro', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-maricleir2@gmail.com', 'maricleir2@gmail.com', 'maria claudia granados valenzuela', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jeniffervente.publicidad@gmail.com', 'jeniffervente.publicidad@gmail.com', 'Jeniffer Venté', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tiendalunabymarisol@gmail.com', 'tiendalunabymarisol@gmail.com', 'Marisol Luna cano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejandra.parraq04@gmail.com', 'alejandra.parraq04@gmail.com', 'Maria alejandra parra quevedo', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-dasha.planticas@gmail.com', 'dasha.planticas@gmail.com', 'Diana Gama', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marcelsalazar80@hotmail.com', 'marcelsalazar80@hotmail.com', 'Marcel Salazar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-misabel_rivera@hotmail.com', 'misabel_rivera@hotmail.com', 'María Isabel Rivera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-leidy.4491@gmail.com', 'leidy.4491@gmail.com', 'Leidy Johanna Agudelo Arango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-loamylobo656@gmail.com', 'loamylobo656@gmail.com', 'Ruth loamy', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-intluiscorrea@gmail.com', 'intluiscorrea@gmail.com', 'LUIS CARMELO CORREA MIRANDA', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-clarainesaristizabal0421@gmail.com', 'clarainesaristizabal0421@gmail.com', 'Clara Inés', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diegogz.2709@gmail.com', 'diegogz.2709@gmail.com', 'Diego Garcia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maria.francho@hotmail.com', 'maria.francho@hotmail.com', 'Maria del mar franco Gaviria', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-racast163043@gmail.com', 'racast163043@gmail.com', 'Rafael Castellanos', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-fabio157maje@gmail.com', 'fabio157maje@gmail.com', 'Fabio Maje', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-camilavelasquez721@gmail.com', 'camilavelasquez721@gmail.com', 'Maria camila velasquez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juantorres2589@gmail.com', 'juantorres2589@gmail.com', 'Juan Manuel Torres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alex.28.92@icloud.com', 'alex.28.92@icloud.com', 'Jhoan Alejandro Gil', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-camiloaguirre1806@gmail.com', 'camiloaguirre1806@gmail.com', 'Camilo Aguirre Vargas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-floryreyes2090@gmail.com', 'floryreyes2090@gmail.com', 'Florencia Reyes', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-miguelfotos162@gmail.com', 'miguelfotos162@gmail.com', 'Miguel Rivera', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-leidymarcelamedinasanchez@hotmail.com', 'leidymarcelamedinasanchez@hotmail.com', 'leidy marcela medina sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nicolarango20@hotmail.com', 'nicolarango20@hotmail.com', 'Nicol Arango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bigpotentialmarketing@gmail.com', 'bigpotentialmarketing@gmail.com', 'Diego Gómez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-katerineareiza75@gmail.com', 'katerineareiza75@gmail.com', 'Katerine areiza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-storedn20@gmail.com', 'storedn20@gmail.com', 'Jerson Giovanny Diaz Gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sjuan7709@gmail.com', 'sjuan7709@gmail.com', 'Camilo Sanchez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lmbv15011979@gmail.com', 'lmbv15011979@gmail.com', 'Luz Marina Bravo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-microcapilart@gmail.com', 'microcapilart@gmail.com', 'Juan Manuel Hernandez Molina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-salgueroca@hotmail.com', 'salgueroca@hotmail.com', 'Cesar Salguero Castañeda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dk96@outlook.com', 'dk96@outlook.com', 'Andres Erraez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-zuluagaanduquiamayradaniela@gmail.com', 'zuluagaanduquiamayradaniela@gmail.com', 'Daniela Zuluaga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-anacsf96@gmail.com', 'anacsf96@gmail.com', 'ANA CAROLINA SEPULVEDA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-wrcomercioelectronico@gmail.com', 'wrcomercioelectronico@gmail.com', 'Wylliam Alfredo Restrepo Diago', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-camigar808@gmail.com', 'camigar808@gmail.com', 'Naren Camilo García', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jholman314@gmail.com', 'jholman314@gmail.com', 'Jholman Henao', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-argeliachasan@gmail.com', 'argeliachasan@gmail.com', 'Argelia Chacón Sánchez', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-menichinismart@gmail.com', 'menichinismart@gmail.com', 'Arianna Menichini', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-liiscoar@hotmail.com', 'liiscoar@hotmail.com', 'Isabel Corzo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vivicolorsmake.up@gmail.com', 'vivicolorsmake.up@gmail.com', 'Viviana Suarez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-karendell96@hotmail.com', 'karendell96@hotmail.com', 'Karen Dell Tejada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-derlyholpaez89@gmail.com', 'derlyholpaez89@gmail.com', 'Derly yineth holguin', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-davasu88@gmail.com', 'davasu88@gmail.com', 'Daniela Valencia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ricardoggoenaga@gmail.com', 'ricardoggoenaga@gmail.com', 'Ricardo alberto gOnzalez Goenaga', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-etowersit@gmail.com', 'etowersit@gmail.com', 'Edgar Ulises Torres Manzano', 'Reto 15D', 'active', 37.03, 'USD', NOW()),
  ('RETO15D-patymatikas@gmail.com', 'patymatikas@gmail.com', 'Patricia Espinel', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-pierpulido@gmail.com', 'pierpulido@gmail.com', 'pier paulo pulido perez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-delarosacreativos@gmail.com', 'delarosacreativos@gmail.com', 'Abisays Elias Moreno C.', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-loyolaovallema@gmail.com', 'loyolaovallema@gmail.com', 'Maira Loyola', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-paomylepr@gmail.com', 'paomylepr@gmail.com', 'Paola Ruiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-santo-357@hotmail.com', 'santo-357@hotmail.com', 'James Aristizabal', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cflorezpinilla@gmail.com', 'cflorezpinilla@gmail.com', 'CAROL JOHANNA FLOREZ PINILLA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sergiogg200404@gmail.com', 'sergiogg200404@gmail.com', 'Sergio Gaitan Guerrero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-esperanza733@hotmail.com', 'esperanza733@hotmail.com', 'Diana Esperanza Páez Arias', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-catarias.81@gmail.com', 'catarias.81@gmail.com', 'Sandra Catalina Arias arango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jeco23@hotmail.com', 'jeco23@hotmail.com', 'Jeferson Correa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yulicasfra@gmail.com', 'yulicasfra@gmail.com', 'Yuliana Castro Franco', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-priscyg@gmail.com', 'priscyg@gmail.com', 'Priscila G', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-camilach.25@outlook.com', 'camilach.25@outlook.com', 'Camila chavista', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cristian09giraldo@gmail.com', 'cristian09giraldo@gmail.com', 'Cristian Serna Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mariafonnegra11@gmail.com', 'mariafonnegra11@gmail.com', 'Maria Jisnedy Salazar Fonnegra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tacasaurio@gmail.com', 'tacasaurio@gmail.com', 'Miguel Angel Tamayo cano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-elmundodelaplatachile@gmail.com', 'elmundodelaplatachile@gmail.com', 'Gloria Garcia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mafe_andrade@hotmail.com', 'mafe_andrade@hotmail.com', 'fernanda andrade', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-melgarejo07@hotmail.com', 'melgarejo07@hotmail.com', 'Edwin Suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ivalencia29@hotmail.com', 'ivalencia29@hotmail.com', 'amanda Isabel Valencia', 'Reto 15D', 'active', 37.05, 'USD', NOW()),
  ('RETO15D-andreabriceno_15@hotmail.com', 'andreabriceno_15@hotmail.com', 'Jenny Andrea briceno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lilivel87@hotmail.com', 'lilivel87@hotmail.com', 'Liliana Velasquez García', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-lissethmarcela1@gmail.com', 'lissethmarcela1@gmail.com', 'Lisseth Marcela Álvarez Muentes', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-mapug.educacion@gmail.com', 'mapug.educacion@gmail.com', 'Maira Puerta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-emreyesq@gmail.com', 'emreyesq@gmail.com', 'Erica Marcela Reyes Quebrada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-meneses.co@softmix.click', 'meneses.co@softmix.click', 'Felipe Meneses', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dracarlacardenas@gmail.com', 'dracarlacardenas@gmail.com', 'Carla Cardenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-iskralanducci96@gmail.com', 'iskralanducci96@gmail.com', 'Iskra landucci', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-andres.sosa01@hotmail.com', 'andres.sosa01@hotmail.com', 'Zamir andres sosa parra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cgstudiove@gmail.com', 'cgstudiove@gmail.com', 'Diana Granado', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-catherine.baronc@gmail.com', 'catherine.baronc@gmail.com', 'Catherine Baron', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yralisbetancourt70@gmail.com', 'yralisbetancourt70@gmail.com', 'Yralis Hayde Betancourt Guevara', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-akire1784@hotmail.com', 'akire1784@hotmail.com', 'Erika sepulveda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angieepa19@gmail.com', 'angieepa19@gmail.com', 'Angie duque', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angelaordonez1234@gmail.com', 'angelaordonez1234@gmail.com', 'Luz Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lindawongvillacis@yahoo.es', 'lindawongvillacis@yahoo.es', 'Linda Wong Villacis', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-karenfuxion24@gmail.com', 'karenfuxion24@gmail.com', 'Karen ochoa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maye.t.gomez@hotmail.com', 'maye.t.gomez@hotmail.com', 'Mayerly torres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marypatry54@hotmail.com', 'marypatry54@hotmail.com', 'María Patricia Candanoza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gonzalez.jek@gmail.com', 'gonzalez.jek@gmail.com', 'Jessika González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-robertojose032019@gmail.com', 'robertojose032019@gmail.com', 'Roberto Jose Suarez Mejia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carlosfabianrojas10@hotmail.com', 'carlosfabianrojas10@hotmail.com', 'Carlos fabian Rojas bocanegra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-limalemu@gmail.com', 'limalemu@gmail.com', 'Lina Marcela Leal Murgas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fragancee8@gmail.com', 'fragancee8@gmail.com', 'Maria fernanda hernandez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yuriprojas@yahoo.es', 'yuriprojas@yahoo.es', 'Yuri Rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mxzonestore@gmail.com', 'mxzonestore@gmail.com', 'mx zone store', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresfella@hotmail.com', 'andresfella@hotmail.com', 'Andres Felipe Llanos Suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carolina.blanco@velawhite.com', 'carolina.blanco@velawhite.com', 'Carolina Blanco', 'Reto 15D', 'active', 35.99, 'USD', NOW()),
  ('RETO15D-ricardopinilla9@hotmail.com', 'ricardopinilla9@hotmail.com', 'Ricardo Pinilla', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jjairo171@gmail.com', 'jjairo171@gmail.com', 'jhon jairo Nuñez peña', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-studiolombaitcorp@gmail.com', 'studiolombaitcorp@gmail.com', 'Natasha figueroa', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-wilopupilo@gmail.com', 'wilopupilo@gmail.com', 'Wiliam Mera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carolinarueda1608@gmail.com', 'carolinarueda1608@gmail.com', 'Carolina Bolívar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lgjohana10@gmail.com', 'lgjohana10@gmail.com', 'Johana londoño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-guzceballos1@gmail.com', 'guzceballos1@gmail.com', 'Gustavo Ceballos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-patosandy2711@gmail.com', 'patosandy2711@gmail.com', 'Sandra Monroy', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mardiazin@gmail.com', 'mardiazin@gmail.com', 'Mar Díaz Rodriguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-soniavera38@gmail.com', 'soniavera38@gmail.com', 'Sonia vera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-laucanina@outlook.com', 'laucanina@outlook.com', 'Raul Lozano alvernia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-shepard.ohonsi.sob@gmail.com', 'shepard.ohonsi.sob@gmail.com', 'Shepard ohonsi', 'Reto 15D', 'active', 37.03, 'USD', NOW()),
  ('RETO15D-zullyalejandra@gmail.com', 'zullyalejandra@gmail.com', 'ZULLY A RUEDA E', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-addys2353@gmail.com', 'addys2353@gmail.com', 'ADDYS PARRA CRUZ', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-danielaospinarmodel@gmail.com', 'danielaospinarmodel@gmail.com', 'Daniela Ospina Ríos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leidymillan23@gmail.com', 'leidymillan23@gmail.com', 'Leidy Millan', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-daniroman27@hotmail.com', 'daniroman27@hotmail.com', 'Daniela Roman', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nana_saldarriaga@hotmail.com', 'nana_saldarriaga@hotmail.com', 'Nana Saldarriaga', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gerencia.idh@gmail.com', 'gerencia.idh@gmail.com', 'Guillermo Molina González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nunezyasira88@gmail.com', 'nunezyasira88@gmail.com', 'Yasira nunez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gutierrezclady@gmail.com', 'gutierrezclady@gmail.com', 'Lady Gutiérrez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-amorenoc100@yahoo.es', 'amorenoc100@yahoo.es', 'luz Ángela moreno', 'Reto 15D', 'active', 36.84, 'USD', NOW()),
  ('RETO15D-cursos@markiany.com', 'cursos@markiany.com', 'Marcos Calvo Arroyo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mpiedrahitagutierrez@gmail.com', 'mpiedrahitagutierrez@gmail.com', 'Maria alejandra piedrahita', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jjcolorador@gmail.com', 'jjcolorador@gmail.com', 'Juan José', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pepitoperez007@protonmail.com', 'pepitoperez007@protonmail.com', 'Pedro Perez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pangeabeer@gmail.com', 'pangeabeer@gmail.com', 'Oscar Quiñones niño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-linalotteart@gmail.com', 'linalotteart@gmail.com', 'Caro Montenegro', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-bajosusalasarte@gmail.com', 'bajosusalasarte@gmail.com', 'Jessica Arenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-familiaalexaspa@gmail.com', 'familiaalexaspa@gmail.com', 'Alexandra Torres Valencia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dramosyarleque@gmail.com', 'dramosyarleque@gmail.com', 'Daniel Ramos', 'Reto 15D', 'active', 37.46, 'USD', NOW()),
  ('RETO15D-pipe_duque@hotmail.com', 'pipe_duque@hotmail.com', 'Andres Felipe Duque Restrepo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-deyarubio@gmail.com', 'deyarubio@gmail.com', 'Deyanira Rubio', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-blendysramos@gmail.com', 'blendysramos@gmail.com', 'BLENDYS RAMOS', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-prisvivarv@gmail.com', 'prisvivarv@gmail.com', 'Priscila Vivar', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-isahh25@gmail.com', 'isahh25@gmail.com', 'Isabela Hoyos Hoyos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-remolinaalbert@gmail.com', 'remolinaalbert@gmail.com', 'Albert Remolina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mazzarelli2017@gmail.com', 'mazzarelli2017@gmail.com', 'Gian Mazzarelli', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-giovanni.alf.mar@gmail.com', 'giovanni.alf.mar@gmail.com', 'Giovanni Martina', 'Reto 15D', 'active', 37.45, 'USD', NOW()),
  ('RETO15D-gabo71136244@gmail.com', 'gabo71136244@gmail.com', 'Gabriel Rodríguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-bibianita12@hotmail.com', 'bibianita12@hotmail.com', 'BIBIANA GAVIRIA T', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-harrymdigital@outlook.com', 'harrymdigital@outlook.com', 'Harry Moreno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marcelastefany9@gmail.com', 'marcelastefany9@gmail.com', 'marcela perez mesa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-holy.interiorfemenino@gmail.com', 'holy.interiorfemenino@gmail.com', 'Norma Cristina Pérez Hurtado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-xiomyhenao18@hotmail.es', 'xiomyhenao18@hotmail.es', 'Xiomara Henao', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lilipod12@hotmail.com', 'lilipod12@hotmail.com', 'jeancob tavera', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-lpablo59@gmail.com', 'lpablo59@gmail.com', 'Pablo David León Curimilma', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-pilotoguerrero281@gmail.com', 'pilotoguerrero281@gmail.com', 'Daniel felipe Guerrero Montilla', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-infolizhernandez@gmail.com', 'infolizhernandez@gmail.com', 'lyceth Paola Bustos Hernandez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-christianleoval@hotmail.com', 'christianleoval@hotmail.com', 'Christian Christian Valencia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carolina.tabarez.ct@gmail.com', 'carolina.tabarez.ct@gmail.com', 'Caro Tabarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mad6812@gmail.com', 'mad6812@gmail.com', 'Miguel Angel Delgado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-infomeliospinacocinacocina@gmail.com', 'infomeliospinacocinacocina@gmail.com', 'Meli Ospina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-csmafra@gmail.com', 'csmafra@gmail.com', 'Marisol Ortega Franco', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-qdenisse@gmail.com', 'qdenisse@gmail.com', 'DENISSE MICHELLE QUIMI CAICEDO', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-velagiraldo@gmail.com', 'velagiraldo@gmail.com', 'Lina Marcela Vela Giraldo', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-pattylunadr@gmail.com', 'pattylunadr@gmail.com', 'Elsa Patricia Luna', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-katelonga@hotmail.com', 'katelonga@hotmail.com', 'Katherine Longa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-docabreras.pe@gmail.com', 'docabreras.pe@gmail.com', 'Victor Cabrera', 'Reto 15D', 'active', 37.44, 'USD', NOW()),
  ('RETO15D-jess0235marketing@gmail.com', 'jess0235marketing@gmail.com', 'Jessica barroeta', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-andrewzerva0903@gmail.com', 'andrewzerva0903@gmail.com', 'Andres Eduardo Cervantes Diaz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mariana.valenciac@autonoma.edu.co', 'mariana.valenciac@autonoma.edu.co', 'Mariana Valencia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johsef4dmrs@gmail.com', 'johsef4dmrs@gmail.com', 'Johsef Palomino Cardos', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-zapataduberandres@gmail.com', 'zapataduberandres@gmail.com', 'Duber Andres Zapata', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sebastianlondonoj@gmail.com', 'sebastianlondonoj@gmail.com', 'Sebastian Londoño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresgiraldo325@gmail.com', 'andresgiraldo325@gmail.com', 'Carlos andres Giraldo hernandez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hassel.ortegapelaez@gmail.com', 'hassel.ortegapelaez@gmail.com', 'Hassel Ortega pelaez', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-jamerq.91@gmail.com', 'jamerq.91@gmail.com', 'Jamer Quinchia Quinchia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-brayangonzalesmejia321@gmail.com', 'brayangonzalesmejia321@gmail.com', 'Brayan Gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-perla_87743@hotmail.com', 'perla_87743@hotmail.com', 'Perla Espinoza', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-germancorreamarin@gmail.com', 'germancorreamarin@gmail.com', 'German correa', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gcamachoh95@gmail.com', 'gcamachoh95@gmail.com', 'Guadalupe Camacho Hernández', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-yureesly1981@gmail.com', 'yureesly1981@gmail.com', 'Yureisly Fernández Castillo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-cardonacami29@gmail.com', 'cardonacami29@gmail.com', 'Maria Camila Cardona Muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pedropaucar37@gmail.com', 'pedropaucar37@gmail.com', 'Pedro paucar', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lissoexpresvip@gmail.com', 'lissoexpresvip@gmail.com', 'Jenniffer Monroy', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-emprendeconalexa@gmail.com', 'emprendeconalexa@gmail.com', 'Alexandra Milena Gonzalez Wilches', 'Reto 15D', 'active', 36.77, 'USD', NOW()),
  ('RETO15D-anndres903@gmail.com', 'anndres903@gmail.com', 'Andres Amezquita', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-laagmvz@gmail.com', 'laagmvz@gmail.com', 'Luz Adriana Arenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dianapatriciaca@gmail.com', 'dianapatriciaca@gmail.com', 'Diana Calle', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angel.aycardi@outlook.com', 'angel.aycardi@outlook.com', 'Angel Dario Aycardi Calume', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jamesvdigital@gmail.com', 'jamesvdigital@gmail.com', 'Jaime Ospina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juanjo.0121@outlook.com', 'juanjo.0121@outlook.com', 'Juan José rojas', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-dianatristancholache@gmail.com', 'dianatristancholache@gmail.com', 'Diana Tristancho', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nomadasdecorazontravel@gmail.com', 'nomadasdecorazontravel@gmail.com', 'Oscar Rodríguez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-sallymay08@hotmail.com', 'sallymay08@hotmail.com', 'Sally May', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diani.sierra@yahoo.com', 'diani.sierra@yahoo.com', 'Diana Sierra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-erikaplatas01@gmail.com', 'erikaplatas01@gmail.com', 'Erika Plata', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fafr81294@gmail.com', 'fafr81294@gmail.com', 'Francis Flores', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gabiuss25@hotmail.com', 'gabiuss25@hotmail.com', 'Gabriela Montenegro', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-fabiolaandueza@gmail.com', 'fabiolaandueza@gmail.com', 'Fabiola Andueza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-adrianapramirezo@hotmail.com', 'adrianapramirezo@hotmail.com', 'ADRIANA RAMIREZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-beatrizhernandezc1@gmail.com', 'beatrizhernandezc1@gmail.com', 'Beatriz elena  Hernández Carmona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-armoventas.atencion@gmail.com', 'armoventas.atencion@gmail.com', 'Gilberto Ramírez Cervera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sayu.cantillo@gmail.com', 'sayu.cantillo@gmail.com', 'sayurys cantillo', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-raquelramirez15@gmail.com', 'raquelramirez15@gmail.com', 'Raquel Ramírez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-2dfavilla@gmail.com', '2dfavilla@gmail.com', 'Diana Agudelo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-benja.flores.bta@gmail.com', 'benja.flores.bta@gmail.com', 'Reynaldo benjamin flores bautista', 'Reto 15D', 'active', 37.07, 'USD', NOW()),
  ('RETO15D-lilianahl@icloud.com', 'lilianahl@icloud.com', 'LILIANA HERRERA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jasipachano@gmail.com', 'jasipachano@gmail.com', 'Jassiell pachano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fager777@gmail.com', 'fager777@gmail.com', 'Elizabeth Fager', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maribel.bellisima501@gmail.com', 'maribel.bellisima501@gmail.com', 'Maribel Alvarez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-yanurca_90@hotmail.com', 'yanurca_90@hotmail.com', 'Yeison antonio Urina castellar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-paolarodriguezrealtor@gmail.com', 'paolarodriguezrealtor@gmail.com', 'Paola rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ariess1986@gmail.com', 'ariess1986@gmail.com', 'Jose zamora', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-aleja_9910_@hotmail.com', 'aleja_9910_@hotmail.com', 'Maria Alejandra Garavito Garzon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yuland8825@hotmail.com', 'yuland8825@hotmail.com', 'Andrea Agudelo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danielaramirez.9394@gmail.com', 'danielaramirez.9394@gmail.com', 'Daniela ramirez Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-patriciadoncel@gmail.com', 'patriciadoncel@gmail.com', 'Eliana Patricia Doncel Munoz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ceo.harleycardozo@gmail.com', 'ceo.harleycardozo@gmail.com', 'Jorge harley cardozo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-deiviaguillon15@gmail.com', 'deiviaguillon15@gmail.com', 'Deivi Aguillon', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lasgordas07@gmail.com', 'lasgordas07@gmail.com', 'Sergio duenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-biancamga1981@gmail.com', 'biancamga1981@gmail.com', 'Bianca garcia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-emmanuellaraosorio@gmail.com', 'emmanuellaraosorio@gmail.com', 'Jesus Emmanuel Lara Osorio', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dayajuanes@gmail.com', 'dayajuanes@gmail.com', 'Dayana Arias palacio', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lozanitoml@gmail.com', 'lozanitoml@gmail.com', 'Adriana Lozano', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-cordobajehiver@gmail.com', 'cordobajehiver@gmail.com', 'Jehiver Córdoba', 'Reto 15D', 'active', 20251021000000, 'USD', NOW()),
  ('RETO15D-francisco16.murilloz@gmail.com', 'francisco16.murilloz@gmail.com', 'Francisco murillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-david_cardona16@hotmail.com', 'david_cardona16@hotmail.com', 'David Leonardo Hidalgo Cardona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tomasina2718@yahoo.com', 'tomasina2718@yahoo.com', 'Tomasina Del rosario mejia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-cryptonano18@gmail.com', 'cryptonano18@gmail.com', 'ONAN TANCO', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-luisamanriquebarrera1995@gmail.com', 'luisamanriquebarrera1995@gmail.com', 'Luisa Fernanda Manrique Barrera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jorgedavidqw@gmail.com', 'jorgedavidqw@gmail.com', 'Jorge David Diaz Rodriguez', 'Reto 15D', 'active', 20251021000000, 'USD', NOW()),
  ('RETO15D-juliajimenezarr@gmail.com', 'juliajimenezarr@gmail.com', 'Julia Jimenez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kam.cuervo@gmail.com', 'kam.cuervo@gmail.com', 'Crysthian Triana', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yaime71@yahoo.com', 'yaime71@yahoo.com', 'Yaime de de la pena zamora', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-tomasm235@gmail.com', 'tomasm235@gmail.com', 'Tomás R Martínez Castaño', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-anamjaramillov@gmail.com', 'anamjaramillov@gmail.com', 'Ana M Jaramillo V', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tatisuarez593@gmail.com', 'tatisuarez593@gmail.com', 'Tatiana Suárez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kevin.valenzuela000@gmail.com', 'kevin.valenzuela000@gmail.com', 'Kevin valenzuela', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gabrielriveravillamizar@gmail.com', 'gabrielriveravillamizar@gmail.com', 'Gabriel Rivera V', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carlos.bismarck36@gmail.com', 'carlos.bismarck36@gmail.com', 'Carlos bismarck', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-cyn.pr16@hotmail.com', 'cyn.pr16@hotmail.com', 'Cynthia pazaran romero', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-dianita1809@hotmail.com', 'dianita1809@hotmail.com', 'Diana guarin', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-paolatca@yahoo.com', 'paolatca@yahoo.com', 'Paola Cardenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresredmusic@gmail.com', 'andresredmusic@gmail.com', 'carlos andres Rodríguez monsalve', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yefersonandreshernandez1@gmail.com', 'yefersonandreshernandez1@gmail.com', 'Yeferson andres Hernandez david', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-zulma_kmc92@hotmail.com', 'zulma_kmc92@hotmail.com', 'Zulma Morales', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-hotmartcmc@gmail.com', 'hotmartcmc@gmail.com', 'Juan Camilo Mojica', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cagd2000@gmail.com', 'cagd2000@gmail.com', 'Carlos Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alexandramazuerarealtor@gmail.com', 'alexandramazuerarealtor@gmail.com', 'Alexandra Mazuera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-vanidadybelleza@hotmail.com', 'vanidadybelleza@hotmail.com', 'Diana Carolina ledezma', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fernandorangel261121@gmail.com', 'fernandorangel261121@gmail.com', 'Fernando Rangel', 'Reto 15D', 'active', 20251021000000, 'USD', NOW()),
  ('RETO15D-piguasbebes@gmail.com', 'piguasbebes@gmail.com', 'Gloria Lucia Dominguez Reyes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-abigailgarcia1512@gmail.com', 'abigailgarcia1512@gmail.com', 'Abigail Garcia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ventasarcangel1@gmail.com', 'ventasarcangel1@gmail.com', 'Paula Andrea Vanegas Salazar', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-judacorps@gmail.com', 'judacorps@gmail.com', 'Manuel Lopez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-loreje28@gmail.com', 'loreje28@gmail.com', 'Jessica lorena ramirez romero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mariatmc.19@gmail.com', 'mariatmc.19@gmail.com', 'Maria Teresa Maldonado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angelatorresm@gmail.com', 'angelatorresm@gmail.com', 'Angela Torres', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-juancarlos0006@gmail.com', 'juancarlos0006@gmail.com', 'Juan Carlos Guerrero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kathemrealestate7@gmail.com', 'kathemrealestate7@gmail.com', 'Katherine Macea Cardona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-amoblandotusideas@gmail.com', 'amoblandotusideas@gmail.com', 'Ivan david aparicio rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-julher1124@hotmail.com', 'julher1124@hotmail.com', 'Julián Andrés Ocoro Hernández', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pabloog979899@gmail.com', 'pabloog979899@gmail.com', 'Pablo ospina gutierrez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marianaandrebanol@gmail.com', 'marianaandrebanol@gmail.com', 'Maríana Banol', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-iliana.inca@gmail.com', 'iliana.inca@gmail.com', 'Iliana Isabel Inca Sanchez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-st.correa93@gmail.com', 'st.correa93@gmail.com', 'stephany correa jimenez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mayerlyn.suarez@gmail.com', 'mayerlyn.suarez@gmail.com', 'Maye Suárez', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-dazaw7@gmail.com', 'dazaw7@gmail.com', 'Wilson Daza Duque', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-astridcarooficial.negocios@gmail.com', 'astridcarooficial.negocios@gmail.com', 'Astrid Carolina Chaves Preciado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fgrleilani@aol.com', 'fgrleilani@aol.com', 'Leilani Figueroa', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-moniburgueno8@gmail.com', 'moniburgueno8@gmail.com', 'Monica burgueno', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-harold.caro29@gmail.com', 'harold.caro29@gmail.com', 'Harold Caro caro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leslieromero2020@gmail.com', 'leslieromero2020@gmail.com', 'Leslie garcia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-larisa.stifiuc@gmail.com', 'larisa.stifiuc@gmail.com', 'Larisa Mihaela Stifiuc', 'Reto 15D', 'active', 37.14, 'USD', NOW()),
  ('RETO15D-vivi.gallego.com@gmail.com', 'vivi.gallego.com@gmail.com', 'Viviana gallego', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marimil.pj@gmail.com', 'marimil.pj@gmail.com', 'Maria Milagros Urdaneta Lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alexacorreajaramillo@gmail.com', 'alexacorreajaramillo@gmail.com', 'Alexa Correa Jaramillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johannamoreano@hotmail.com', 'johannamoreano@hotmail.com', 'Johanna Moreano Garcés', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-acidopotente3@gmail.com', 'acidopotente3@gmail.com', 'Carlos Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kubantmllc@gmail.com', 'kubantmllc@gmail.com', 'Yadira Batista', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-juantorres101705@gmail.com', 'juantorres101705@gmail.com', 'Juan Felipe torres bolaños', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juliquicenoo@gmail.com', 'juliquicenoo@gmail.com', 'Juliana Quiceno Ospina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kevin.trafficker.digital@gmail.com', 'kevin.trafficker.digital@gmail.com', 'Kevin Guerrero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tecnofrutales@gmail.com', 'tecnofrutales@gmail.com', 'Sandra Marcela Cano Betancur', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andii.tostado@gmail.com', 'andii.tostado@gmail.com', 'Andrea Tostado', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-camilonetworking982@gmail.com', 'camilonetworking982@gmail.com', 'camilo andres rodriguez vasquez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cablejireh@gmail.com', 'cablejireh@gmail.com', 'Fabiola Mosquera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-euroxbarber@gmail.com', 'euroxbarber@gmail.com', 'Josue Figueroa', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-isabellasanchezgomez99@gmail.com', 'isabellasanchezgomez99@gmail.com', 'Isabella Sánchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nikoaleja2609@gmail.com', 'nikoaleja2609@gmail.com', 'Maira Alejandra Batista Herazo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dbbermudezs@gmail.com', 'dbbermudezs@gmail.com', 'Dennis Bermudez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luza606@msn.com', 'luza606@msn.com', 'Luza Perez hoyos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-egaleano2827@gmail.com', 'egaleano2827@gmail.com', 'Eliana Galeano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-wladdys1313@gmail.com', 'wladdys1313@gmail.com', 'Wladimir Cadena Benitez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ginanataliasoto@outlook.com', 'ginanataliasoto@outlook.com', 'Gina Natalia Soto', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danielabecerril.diseno@gmail.com', 'danielabecerril.diseno@gmail.com', 'Daniela Becerril', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-linacorrea93@hotmail.com', 'linacorrea93@hotmail.com', 'Lina Correa', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-andreasabando@icloud.com', 'andreasabando@icloud.com', 'Andrea sabando', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-elilorojas@yahoo.com', 'elilorojas@yahoo.com', 'Eliana lotero rojas', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-jeffersonperico1993@gmail.com', 'jeffersonperico1993@gmail.com', 'Jefferson Perico', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dbalcazar@uees.edu.ec', 'dbalcazar@uees.edu.ec', 'Doménica Balcázar', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-evelyniza1995@gmail.com', 'evelyniza1995@gmail.com', 'Evelyn Hincapié Villanueva', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alexgcanog1@gmail.com', 'alexgcanog1@gmail.com', 'Alex Guillermo Cano Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dacore99999@gmail.com', 'dacore99999@gmail.com', 'David Parra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mayerli1205@gmail.com', 'mayerli1205@gmail.com', 'mallerline naranjo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diamogo21@hotmail.com', 'diamogo21@hotmail.com', 'Diyeneis Andrea Moreno Gomez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-anama_eraso@hotmail.com', 'anama_eraso@hotmail.com', 'Ana Maria Eraso', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejasegundacuenta2@gmail.com', 'alejasegundacuenta2@gmail.com', 'Alejandra Ortiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-moreno_t_a@hotmail.com', 'moreno_t_a@hotmail.com', 'Alfredo Moreno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lululoaiza@gmail.com', 'lululoaiza@gmail.com', 'Luisa loaiza', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-juli.mendoza.jam@gmail.com', 'juli.mendoza.jam@gmail.com', 'Julia Mendoza', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ccamilo.molina@gmail.com', 'ccamilo.molina@gmail.com', 'Cristian Camilo Molina Restrepo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejandragrues@gmail.com', 'alejandragrues@gmail.com', 'Yunis Alejandra grueso Baron', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lucecitamejiabaron@gmail.com', 'lucecitamejiabaron@gmail.com', 'Luz Maritza Mejia-Baron', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-doradasbypaolaortiz@gmail.com', 'doradasbypaolaortiz@gmail.com', 'Marco Tabone', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-clio333@hotmail.com', 'clio333@hotmail.com', 'Leonardo Salgado Carmona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angiepala@hotmail.com', 'angiepala@hotmail.com', 'Angelica Palacio', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luoneelop@hotmail.com', 'luoneelop@hotmail.com', 'Ivonee lopez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-danieldonado690@gmail.com', 'danieldonado690@gmail.com', 'Daniel Donado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cristianarango0610@gmail.com', 'cristianarango0610@gmail.com', 'Cristian alejandro arango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pilarbernal08@gmail.com', 'pilarbernal08@gmail.com', 'Pilar Rocío Bernal Gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kellyh1093@gmail.com', 'kellyh1093@gmail.com', 'Kelly Hoyos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-celeste@aicca.com.mx', 'celeste@aicca.com.mx', 'Celeste Beltran', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-marketingbydvg@gmail.com', 'marketingbydvg@gmail.com', 'Daniela Varona', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-sebastianmontes6@gmail.com', 'sebastianmontes6@gmail.com', 'sebastian montes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pymeza@gmail.com', 'pymeza@gmail.com', 'Patricia Yaneth Meza Leal', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-bryan.jaimes24@gmail.com', 'bryan.jaimes24@gmail.com', 'Bryan Jaimes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mia8693@gmail.com', 'mia8693@gmail.com', 'Mia salazar', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-tatianadiezmalagon@gmail.com', 'tatianadiezmalagon@gmail.com', 'Tatiana Diez', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-jwalda91@gmail.com', 'jwalda91@gmail.com', 'Josselyn Waleska Ramos Marroquin', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-sebasmc599@gmail.com', 'sebasmc599@gmail.com', 'Sebastian Medina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-joseval30@yahoo.com', 'joseval30@yahoo.com', 'Jose Guerrero', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-danangarital@gmail.com', 'danangarital@gmail.com', 'Daniel Esteban Angarita Leal', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-cere0720@gmail.com', 'cere0720@gmail.com', 'Cecilia Regalado', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ceregalado68@gmail.com', 'ceregalado68@gmail.com', 'Cecilia Regalado', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-infoclaravelasquez@gmail.com', 'infoclaravelasquez@gmail.com', 'Clara Velasquez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-anyelina84@hotmail.com', 'anyelina84@hotmail.com', 'Angela Patricia Mendez Tello', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-cedaacmx@gmail.com', 'cedaacmx@gmail.com', 'Ana karen beltran lastra', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-jdlopezdu@gmail.com', 'jdlopezdu@gmail.com', 'Juan David Lopez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-paca993@hotmail.com', 'paca993@hotmail.com', 'Paula Arias', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lemosky94@gmail.com', 'lemosky94@gmail.com', 'David esteban lemos caicedo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luismaquesadaborrero@gmail.com', 'luismaquesadaborrero@gmail.com', 'Luis Manuel Quesada Borrero', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-destebanmartinez@icloud.com', 'destebanmartinez@icloud.com', 'Daniel Esteban Martínez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luzstelladuce@gmail.com', 'luzstelladuce@gmail.com', 'Luz Duarte', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pasifico@gmail.com', 'pasifico@gmail.com', 'Javier Angulo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alerojasarizaga@gmail.com', 'alerojasarizaga@gmail.com', 'Ale Rojas', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-berdaju2012@gmail.com', 'berdaju2012@gmail.com', 'Julian Berdugo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cordobakettyyohana@gmail.com', 'cordobakettyyohana@gmail.com', 'Ketty Yohana Córdoba', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juliethleslie049@gmail.com', 'juliethleslie049@gmail.com', 'Ruth Elena Caceres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fercastro.rico@gmail.com', 'fercastro.rico@gmail.com', 'Yennyfer Styffen Castro Rico', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-dalazu0717@gmail.com', 'dalazu0717@gmail.com', 'Daniela lasso zuluaga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-subgerenciaconexiontrip@gmail.com', 'subgerenciaconexiontrip@gmail.com', 'Juan pablo Castañeda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-claudianailstx@gmail.com', 'claudianailstx@gmail.com', 'Claudia herrera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ftalejandragomez@gmail.com', 'ftalejandragomez@gmail.com', 'Alejandra Gómez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-daniigomez08@gmail.com', 'daniigomez08@gmail.com', 'Daniela gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vallejo_7906@hotmail.com', 'vallejo_7906@hotmail.com', 'Oscar Rodriguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-laurahurtado_2018@hotmail.com', 'laurahurtado_2018@hotmail.com', 'Laura marcela hurtado tabares', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gamana2809@gmail.com', 'gamana2809@gmail.com', 'Gabriella Lagonell', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ypr-11@hotmail.com', 'ypr-11@hotmail.com', 'Yeison ricardo pineda Gutiérrez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mariatutyaccesorios@gmail.com', 'mariatutyaccesorios@gmail.com', 'Maria isabel andrade', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-cropmark@me.com', 'cropmark@me.com', 'Jorge A. Murillo', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-caritorincon@gmail.com', 'caritorincon@gmail.com', 'Carolina Rincon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juanramonpro@gmail.com', 'juanramonpro@gmail.com', 'Juan Ramon Pacahuala', 'Reto 15D', 'active', 31.62, 'USD', NOW()),
  ('RETO15D-gabymu1855@gmail.com', 'gabymu1855@gmail.com', 'Gabriela Muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cqg237@gmail.com', 'cqg237@gmail.com', 'Maria Camila Quintero Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-susipulga23@gmail.com', 'susipulga23@gmail.com', 'Susana Pulgarin', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andrecastello@gmail.com', 'andrecastello@gmail.com', 'André Castelló', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-noashopfl@gmail.com', 'noashopfl@gmail.com', 'Natalia Esquivel', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-santanderbarraza@gmail.com', 'santanderbarraza@gmail.com', 'Santander Barraza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kromaticadesign@gmail.com', 'kromaticadesign@gmail.com', 'Laura Duque', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-barbosaperezalejandra@gmail.com', 'barbosaperezalejandra@gmail.com', 'Alejandra Barbosa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-valenti1903@hotmail.com', 'valenti1903@hotmail.com', 'Julieth campo Dorado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ana.roldantv@gmail.com', 'ana.roldantv@gmail.com', 'Ana maria Roldan ospina', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-caicedo.orrego17@gmail.com', 'caicedo.orrego17@gmail.com', 'Angélica Caicedo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-malejagalo3@gmail.com', 'malejagalo3@gmail.com', 'Maira lejandra Galindo Lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-visionbloomstudio@gmail.com', 'visionbloomstudio@gmail.com', 'Natalia Di María', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-germandelgadotoledo@gmail.com', 'germandelgadotoledo@gmail.com', 'German Delgado Toledo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-castanedanicolas08@gmail.com', 'castanedanicolas08@gmail.com', 'Brayan Nicolas Castañeda Vargas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bubalulajey@gmail.com', 'bubalulajey@gmail.com', 'Jennifer Amaya Ulloa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-1993marcela.rios@gmail.com', '1993marcela.rios@gmail.com', 'Jenny marcela ríos Larrea', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luisalinasrealestatemarketing@gmail.com', 'luisalinasrealestatemarketing@gmail.com', 'Luis Salinas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-vegonio276@gmail.com', 'vegonio276@gmail.com', 'John Enrique Navarro Ortiz', 'Reto 15D', 'active', 36.60, 'USD', NOW()),
  ('RETO15D-soarisnovarealtor@gmail.com', 'soarisnovarealtor@gmail.com', 'Soaris Nova', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-aprendecompartiendo2022@gmail.com', 'aprendecompartiendo2022@gmail.com', 'Carlos bedoya', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-v_valdes@outlook.com', 'v_valdes@outlook.com', 'Veronica Valdes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-adri.camargo84@gmail.com', 'adri.camargo84@gmail.com', 'Adriana Camargo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-diegopoveda09@gmail.com', 'diegopoveda09@gmail.com', 'Diego Poveda', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-maleja.pv0209@gmail.com', 'maleja.pv0209@gmail.com', 'Alejandra Patiño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jussie121@gmail.com', 'jussie121@gmail.com', 'Gretty Granobles', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cristhian.p1994@gmail.com', 'cristhian.p1994@gmail.com', 'Cristhian Perez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sorocaimask8@gmail.com', 'sorocaimask8@gmail.com', 'Levys Villafranca', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tobonjudy@gmail.com', 'tobonjudy@gmail.com', 'Judy Tobón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karlasanabria@yahoo.es', 'karlasanabria@yahoo.es', 'Karla sanbria', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lizethduran0321@hotmail.com', 'lizethduran0321@hotmail.com', 'Teresa Duran galeano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-arq.jcjimenez0@gmail.com', 'arq.jcjimenez0@gmail.com', 'Juan camilo Jiménez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-paugonzalezg2017@hotmail.com', 'paugonzalezg2017@hotmail.com', 'Paula Gonzalez Guzmán', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-paulaandreajimenezruiz@gmail.com', 'paulaandreajimenezruiz@gmail.com', 'Paula Andrea Jiménez Ruiz', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-rcsepulveda4@gmail.com', 'rcsepulveda4@gmail.com', 'REBECCA SEPÚLVEDA', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-betancourt.oje@gmail.com', 'betancourt.oje@gmail.com', 'John enrique betancourt ospina', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-betancourthbo@gmail.com', 'betancourthbo@gmail.com', 'Hernán Betancourt Ospina', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-justine14_7@hotmail.com', 'justine14_7@hotmail.com', 'Justine Acosta', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lideres365global@gmail.com', 'lideres365global@gmail.com', 'Hector Galensky Romero Baron', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angelikco09@gmail.com', 'angelikco09@gmail.com', 'angelica Carvajal', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-mateo3329edinsonkate@gmail.com', 'mateo3329edinsonkate@gmail.com', 'Edinson córdoba mosquera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juanselomo@gmail.com', 'juanselomo@gmail.com', 'Juan Sebastián López Molina', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-norisrangel2017@gmail.com', 'norisrangel2017@gmail.com', 'Noris Villarruel', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-heidy.digital@gmail.com', 'heidy.digital@gmail.com', 'Heidy Herrera', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-santiaristi_1994@hotmail.com', 'santiaristi_1994@hotmail.com', 'Santiago guarin Aristizábal', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andre1726_@hotmail.com', 'andre1726_@hotmail.com', 'Andrea Gil lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-milen256@gmail.com', 'milen256@gmail.com', 'Milena Osorio', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-adrianarp06@hotmail.com', 'adrianarp06@hotmail.com', 'Adriana Rojas prado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-klminorta@gmail.com', 'klminorta@gmail.com', 'Karen Lorena minorta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cruzjohana027@gmail.com', 'cruzjohana027@gmail.com', 'Johana Cruz Dorado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ramirezlam80@gmail.com', 'ramirezlam80@gmail.com', 'Luis Ramirez', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-rdavid.mendoza.j@gmail.com', 'rdavid.mendoza.j@gmail.com', 'David Mendoza', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-adri.bulla16@hotmail.com', 'adri.bulla16@hotmail.com', 'Adrián Felipe Bulla Bernal', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-apps@pablodice.mx', 'apps@pablodice.mx', 'Pablo Rodriguez', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-milenagomezarcila@gmail.com', 'milenagomezarcila@gmail.com', 'Olga Milena Gomez Arcila', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-patriciacamelo10@gmail.com', 'patriciacamelo10@gmail.com', 'Patricia camelo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ericklef@hotmail.com', 'ericklef@hotmail.com', 'ERICK DANIEL RAMIREZ MENDEZ', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-juandlondono27@gmail.com', 'juandlondono27@gmail.com', 'Juan David Londoño Valle', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mile.h.g@hotmail.com', 'mile.h.g@hotmail.com', 'Sandra milena Hernandez galeano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angelicarod24@gmail.com', 'angelicarod24@gmail.com', 'Angelica Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-meli.palacio73@gmail.com', 'meli.palacio73@gmail.com', 'Melisa palacio parra', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-oszysalazar@gmail.com', 'oszysalazar@gmail.com', 'Osana M Salazar', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-nataliapastran494@gmail.com', 'nataliapastran494@gmail.com', 'Natalia Saenz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-stefy_0523@hotmail.com', 'stefy_0523@hotmail.com', 'stephane malkun', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-zerolatitude.ms@gmail.com', 'zerolatitude.ms@gmail.com', 'Luis Mosquera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-admicompramas@gmail.com', 'admicompramas@gmail.com', 'Kevin Leandro Sánchez moncaleano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jcorredor82@gmail.com', 'jcorredor82@gmail.com', 'Javier Corredor', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ielvanvan97@gmail.com', 'ielvanvan97@gmail.com', 'Iván Darío cavadia babilonia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-catanoclavijod@gmail.com', 'catanoclavijod@gmail.com', 'Diana Marcela Cataño Clavijo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ansato23@gmail.com', 'ansato23@gmail.com', 'Angelo Samboni', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jma9974@gmail.com', 'jma9974@gmail.com', 'Jhonattan Manrique', 'Reto 15D', 'active', 1.85, 'USD', NOW()),
  ('RETO15D-andresdavid.garciam@gmail.com', 'andresdavid.garciam@gmail.com', 'Andrés García', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-castri-llon@hotmail.com', 'castri-llon@hotmail.com', 'Daniel Castrillon jaramillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yanethroam@hotmail.com', 'yanethroam@hotmail.com', 'ERIKA YANETH ROA MARTINEZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-isandigital2024@gmail.com', 'isandigital2024@gmail.com', 'Isabela Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-catyriveras@gmail.com', 'catyriveras@gmail.com', 'catalina rivera sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dianicuerv07@gmail.com', 'dianicuerv07@gmail.com', 'Diana Cuervo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-coronado_karl@hotmail.com', 'coronado_karl@hotmail.com', 'Karla Coronado', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-andrea_sierra16@hotmail.com', 'andrea_sierra16@hotmail.com', 'María Paula paez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gmgempresas.com@gmail.com', 'gmgempresas.com@gmail.com', 'Giovanny Gonzalez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-do72353@gmail.com', 'do72353@gmail.com', 'Daniel Rusinque', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lele-sanchex1@hotmail.com', 'lele-sanchex1@hotmail.com', 'Celeste Sánchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tradingymas2023@gmail.com', 'tradingymas2023@gmail.com', 'Yuneisi Valdés', 'Reto 15D', 'active', 36.78, 'USD', NOW()),
  ('RETO15D-dylanincrease@gmail.com', 'dylanincrease@gmail.com', 'Victor Medina', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-jximenar1112@gmail.com', 'jximenar1112@gmail.com', 'Jeime Ximena Rincón Pedraza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-info@marcerrealtor.com', 'info@marcerrealtor.com', 'Marcela Otalora', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-francinethemprende@gmail.com', 'francinethemprende@gmail.com', 'Francineth Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marugr.sinergia@gmail.com', 'marugr.sinergia@gmail.com', 'Maria Eugenia Gordillo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-leidixxita-@hotmail.com', 'leidixxita-@hotmail.com', 'Leidy Parada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-geralgonzalez2120@hotmail.com', 'geralgonzalez2120@hotmail.com', 'Geraldin gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nicoleorejuela@icloud.com', 'nicoleorejuela@icloud.com', 'Nicole Orejuela', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-luciannohill@gmail.com', 'luciannohill@gmail.com', 'Gabriel Munoz munoz Camacho', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maribel311216@gmail.com', 'maribel311216@gmail.com', 'Maribel Escobar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leydypaolagarciacelys1994@gmail.com', 'leydypaolagarciacelys1994@gmail.com', 'Leydy paola garcia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-katerinemorales1731@gmail.com', 'katerinemorales1731@gmail.com', 'Katerine Morales', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-valesm09@hotmail.com', 'valesm09@hotmail.com', 'Valentina Suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-crushcalderon635@gmail.com', 'crushcalderon635@gmail.com', 'Liliana calderon martinez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kattygutierrezr.gdh@gmail.com', 'kattygutierrezr.gdh@gmail.com', 'Katty Gutiérrez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angelik_mrm@hotmail.com', 'angelik_mrm@hotmail.com', 'Angelica Rodríguez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-marialegtz@gmail.com', 'marialegtz@gmail.com', 'Maria Alejandra Gutierrez De Piñeres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ujohana@hotmail.com', 'ujohana@hotmail.com', 'Kelly johana Uribe agudelo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-anita.erira12@gmail.com', 'anita.erira12@gmail.com', 'Anita Mercedes Erira Aza', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-obethcelio29@gmail.com', 'obethcelio29@gmail.com', 'OBETH CELIO HUAMAN HUANCA', 'Reto 15D', 'active', 37.28, 'USD', NOW()),
  ('RETO15D-tatilamprea02@gmail.com', 'tatilamprea02@gmail.com', 'Tatiana Lamprea ochoa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tativ215@gmail.com', 'tativ215@gmail.com', 'TATIANA vargas', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-antovalencia12@hotmail.com', 'antovalencia12@hotmail.com', 'Antonela Valencia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jennifer_wk@yahoo.com.co', 'jennifer_wk@yahoo.com.co', 'Liliana Espinosa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-smmb24@gmail.com', 'smmb24@gmail.com', 'Stephany Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juandaramirez1983@gmail.com', 'juandaramirez1983@gmail.com', 'Juan David Ramírez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-marianaflorezu@gmail.com', 'marianaflorezu@gmail.com', 'Mariana Flórez Urrego', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-agenciatravelsai@gmail.com', 'agenciatravelsai@gmail.com', 'Zayda molina', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-vivianagiraldop85@gmail.com', 'vivianagiraldop85@gmail.com', 'Viviana Giraldo', 'Reto 15D', 'active', 37.26, 'USD', NOW()),
  ('RETO15D-estefania_2709@hotmail.com', 'estefania_2709@hotmail.com', 'Estefania López', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nurypacheco25@hotmail.com', 'nurypacheco25@hotmail.com', 'Nury pacheco', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andreaherrera8921@gmail.com', 'andreaherrera8921@gmail.com', 'Nelfry herrera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kimfloresv@gmail.com', 'kimfloresv@gmail.com', 'Kimberling Flores', 'Reto 15D', 'active', 37.26, 'USD', NOW()),
  ('RETO15D-luisavasquezcomunicadora@gmail.com', 'luisavasquezcomunicadora@gmail.com', 'Luisa fernanda vasquez cuartas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gelatoitalianoartesanal@gmail.com', 'gelatoitalianoartesanal@gmail.com', 'Fabrizio Scribante', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-perlanc.cursos@gmail.com', 'perlanc.cursos@gmail.com', 'Perla Navarro', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-stivenbl517@gmail.com', 'stivenbl517@gmail.com', 'Luis Stiven balsero lopez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-miopticag.o@gmail.com', 'miopticag.o@gmail.com', 'Greisy osma', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rocketeamproducciones@gmail.com', 'rocketeamproducciones@gmail.com', 'RAMON ANDRES MOROS ORTIZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-espinolafigueroajesusleonel@gmail.com', 'espinolafigueroajesusleonel@gmail.com', 'Jesus Espinola', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alejandromedinaiin@gmail.com', 'alejandromedinaiin@gmail.com', 'Alejandro Medina Medina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kevinmontesdeocarivas@gmail.com', 'kevinmontesdeocarivas@gmail.com', 'Kevin montes de oca', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marthameru22@gmail.com', 'marthameru22@gmail.com', 'Martha Eugenia Meza Ruiz', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-mikealfonsomusic@gmail.com', 'mikealfonsomusic@gmail.com', 'Miguel Alfonso Rodriguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-caenthi0502@gmail.com', 'caenthi0502@gmail.com', 'Carlos Rausseo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-dannyluque123@gmail.com', 'dannyluque123@gmail.com', 'Danny Luque lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cadete711@gmail.com', 'cadete711@gmail.com', 'Victor lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sugey_1279@hotmail.com', 'sugey_1279@hotmail.com', 'Sugey Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diegoupel35@gmail.com', 'diegoupel35@gmail.com', 'Diego Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lauranicoll.chacon@gmail.com', 'lauranicoll.chacon@gmail.com', 'Laura Nicoll Chacon Forero', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-ajolon@gmail.com', 'ajolon@gmail.com', 'Jose Jolon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carvajalm295@gmail.com', 'carvajalm295@gmail.com', 'Mayra alejandra carvajal carrillo', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-josemiguelfbz337@gmail.com', 'josemiguelfbz337@gmail.com', 'José Miguel Torres Torres', 'Reto 15D', 'active', 20251021000000, 'USD', NOW()),
  ('RETO15D-jonathan.d.12@hotmail.com', 'jonathan.d.12@hotmail.com', 'Jonathan david Vargas piedrahita', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alvarez.pao@gmail.com', 'alvarez.pao@gmail.com', 'Paola Alvarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mporritasg@gmail.com', 'mporritasg@gmail.com', 'Magda Porras', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-pardok94@gmail.com', 'pardok94@gmail.com', 'Kevin jose Pardo lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-esperanza@ehopeusa.com', 'esperanza@ehopeusa.com', 'Esperanza Bustamante', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jeniferisazaluna@gmail.com', 'jeniferisazaluna@gmail.com', 'Jenifer Isaza Luna', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dianaarizam87@gmail.com', 'dianaarizam87@gmail.com', 'Diana Ariza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karyviqueira@gmail.com', 'karyviqueira@gmail.com', 'Karina Viqueira', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-susanabarahona21@gmail.com', 'susanabarahona21@gmail.com', 'Susana Barahona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-koke.macias@gmail.com', 'koke.macias@gmail.com', 'Jorge Macias', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sandraurqui1@gmail.com', 'sandraurqui1@gmail.com', 'Sandra Urquijo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-beraguirre@gmail.com', 'beraguirre@gmail.com', 'Bernardita Aguirre', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-activalamujer@hotmail.com', 'activalamujer@hotmail.com', 'sandra Ramón', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-jenniferquimbayo92@gmail.com', 'jenniferquimbayo92@gmail.com', 'Jennifer quimbayo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cordovaalejandra29@gmail.com', 'cordovaalejandra29@gmail.com', 'Alejandra Cordova Murillo', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-misabelvillar@hotmail.com', 'misabelvillar@hotmail.com', 'Isabel Villa', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-gabriel.cifuentes.m@gmail.com', 'gabriel.cifuentes.m@gmail.com', 'Gabriel Cifuentes', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-academy777lhm@gmail.com', 'academy777lhm@gmail.com', 'Luis Hernando Medrano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marielapollastrini18@gmail.com', 'marielapollastrini18@gmail.com', 'Mariela Pollastrini', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-solucionmaldonado67@gmail.com', 'solucionmaldonado67@gmail.com', 'Luis Suarez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kathy_sofi95@hotmail.com', 'kathy_sofi95@hotmail.com', 'Katheryn Sofia Temoche', 'Reto 15D', 'active', 37.19, 'USD', NOW()),
  ('RETO15D-boriscometta27@gmail.com', 'boriscometta27@gmail.com', 'Boris cometta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-opticanewtonsa@gmail.com', 'opticanewtonsa@gmail.com', 'Sandra Liliana Martinez Quintero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lauryrua95@gmail.com', 'lauryrua95@gmail.com', 'Laury Rua', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alberto_acosta1@hotmail.com', 'alberto_acosta1@hotmail.com', 'Alberto Acosta', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nataliahl2010@hotmail.com', 'nataliahl2010@hotmail.com', 'Olga Hernandez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-topteninmobiliaria55@gmail.com', 'topteninmobiliaria55@gmail.com', 'Don José', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-pablocelis11@gmail.com', 'pablocelis11@gmail.com', 'Pablo Celis', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karendiazm@hotmail.com', 'karendiazm@hotmail.com', 'Karen Diaz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hoyosjeimy96@gmail.com', 'hoyosjeimy96@gmail.com', 'Jeimy echeverry', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yeshuarodriguezsilva@gmail.com', 'yeshuarodriguezsilva@gmail.com', 'Yeshua Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-xp.yar4@gmail.com', 'xp.yar4@gmail.com', 'Yarmila Marianela Hinojosa Fernandez', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-adoariza05@gmail.com', 'adoariza05@gmail.com', 'Adolfina Ariza Herrera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jorgefilmmaking@gmail.com', 'jorgefilmmaking@gmail.com', 'Jorge Luis Muñoz Pinto', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-caroll91rodriguez@gmail.com', 'caroll91rodriguez@gmail.com', 'Marlenny Domínguez Mengo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gercysimet8@gmail.com', 'gercysimet8@gmail.com', 'Gercy simet', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-dimaleva_58@hotmail.com', 'dimaleva_58@hotmail.com', 'Diana Maria Leyva Vargas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-camiloandresp19@hotmail.com', 'camiloandresp19@hotmail.com', 'Camilo Andres Patiño Mesa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-banuelosmd@gmail.com', 'banuelosmd@gmail.com', 'Sr JESUS BANUELOS', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tarangoplay@gmail.com', 'tarangoplay@gmail.com', 'Valentina Hincapié', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andreaceh16@gmail.com', 'andreaceh16@gmail.com', 'Andrea Escobar Herrera', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-alejo20j@gmail.com', 'alejo20j@gmail.com', 'Alejandro Montoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vivianasamaniego1283@gmail.com', 'vivianasamaniego1283@gmail.com', 'viviana Samaniego Hoyos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rbnguillermo@gmail.com', 'rbnguillermo@gmail.com', 'rubenb guillermo ccapa huaricallo', 'Reto 15D', 'active', 37.34, 'USD', NOW()),
  ('RETO15D-santyadss@gmail.com', 'santyadss@gmail.com', 'Santiago Muñoz Pineda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-biscuerobayo@hotmail.com', 'biscuerobayo@hotmail.com', 'Jaiver Biscue', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andrea@andreaodle.com', 'andrea@andreaodle.com', 'Andrea Odle', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-acuerdosfinancierosldc@gmail.com', 'acuerdosfinancierosldc@gmail.com', 'Luis David Caselles Rodriguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-steffy.veliz23@gmail.com', 'steffy.veliz23@gmail.com', 'Steffy Veliz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-coordinacioneventosvictoria@gmail.com', 'coordinacioneventosvictoria@gmail.com', 'Victoria Osorio santofimio', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-jefferson.marben10@gmail.com', 'jefferson.marben10@gmail.com', 'Jefferson Martinez Benitez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-kte-navarro@hotmail.com', 'kte-navarro@hotmail.com', 'Katherine Navarro', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-paulitha3110@gmail.com', 'paulitha3110@gmail.com', 'Paula Andrea Garzón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angelacusco2019@gmail.com', 'angelacusco2019@gmail.com', 'ANGELA RIVERA', 'Reto 15D', 'active', 37.34, 'USD', NOW()),
  ('RETO15D-gromit4800@gmail.com', 'gromit4800@gmail.com', 'Jonathan Orduño molina', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-hmolanopatino@gmail.com', 'hmolanopatino@gmail.com', 'Holman molano patino', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-armandochazari@gmail.com', 'armandochazari@gmail.com', 'Gerardo Chazarí', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-brepaca725@gmail.com', 'brepaca725@gmail.com', 'Brenda Palacio Carrasquilla', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jenny.povedar@gmail.com', 'jenny.povedar@gmail.com', 'Yenny Alexandra Poveda Rincón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ceojairoavalos@gmail.com', 'ceojairoavalos@gmail.com', 'Jairo Avalos', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-lozano_702@hotmail.com', 'lozano_702@hotmail.com', 'JESUS LOZANO', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-adricaballero10@hotmail.com', 'adricaballero10@hotmail.com', 'Adriana Caballero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sebasrojasm@gmail.com', 'sebasrojasm@gmail.com', 'Juan sebastian Rojas martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-nicolshopiavanegasarenas@gmail.com', 'nicolshopiavanegasarenas@gmail.com', 'Nicol Sofia Vanegas Arenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sindyanez05@gmail.com', 'sindyanez05@gmail.com', 'Cindy Yanez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lore.leon2412@gmail.com', 'lore.leon2412@gmail.com', 'Loreana Villabona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-info@samuelfranco.com', 'info@samuelfranco.com', 'Samuel Franco', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gustavoguerraventas@gmail.com', 'gustavoguerraventas@gmail.com', 'Gustavo Guerra ventas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-opt.a_armendariz@outlook.com', 'opt.a_armendariz@outlook.com', 'Anabel Alexandra Armendariz Velasquez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-asanchezp1974@gmail.com', 'asanchezp1974@gmail.com', 'Andre Sanchez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-concejalnicolas@gmail.com', 'concejalnicolas@gmail.com', 'Nicolas Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-modebonilla@cococreativo.com.mx', 'modebonilla@cococreativo.com.mx', 'Modesto Bonilla', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-anagaviriar05@gmail.com', 'anagaviriar05@gmail.com', 'Ana Maria Gaviria Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-m.jair2819@gmail.com', 'm.jair2819@gmail.com', 'Marcos Cuervo', 'Reto 15D', 'active', 36.54, 'USD', NOW()),
  ('RETO15D-sxmauroxe@gmail.com', 'sxmauroxe@gmail.com', 'Mauricio Velez rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jart85@gmail.com', 'jart85@gmail.com', 'Javiana Artuza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jmendezcalle@yahoo.com', 'jmendezcalle@yahoo.com', 'Jennyfer Méndez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gerencia@atiempo.com.ec', 'gerencia@atiempo.com.ec', 'Roberto Leon', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-bluagencia2021@gmail.com', 'bluagencia2021@gmail.com', 'Andres Godoy', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-glendafernandez777@icloud.com', 'glendafernandez777@icloud.com', 'Glenda jucceli fernandez lizarraga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cpn.hugosolalinde@gmail.com', 'cpn.hugosolalinde@gmail.com', 'Hugo Solalinde', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gomezmilena781@gmail.com', 'gomezmilena781@gmail.com', 'Milena Gómez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-felipedr161@hotmail.com', 'felipedr161@hotmail.com', 'Felipe Davila Rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jhonyquevedo@gmail.com', 'jhonyquevedo@gmail.com', 'JHONATAN SEBASTIAN QUEVEDO JIMENEZ', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-alojah83@gmail.com', 'alojah83@gmail.com', 'Adriana LOJA', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-marceco1975@hotmail.com', 'marceco1975@hotmail.com', 'Marcela Correa', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-hernandezmartinezalexis@gmail.com', 'hernandezmartinezalexis@gmail.com', 'Alexis Hernandez Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-caprietos@yahoo.com', 'caprietos@yahoo.com', 'Carlos Alberto Prieto', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lizeth27642@hotmail.com', 'lizeth27642@hotmail.com', 'Lizeth Castro Yepes', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-sebastianrc15.2@gmail.com', 'sebastianrc15.2@gmail.com', 'Sebastian Cardona', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-hortensia@encasapanama.com', 'hortensia@encasapanama.com', 'Hortensia Allen', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-lewistrp@gmail.com', 'lewistrp@gmail.com', 'Lewis Pineda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diana19484@hotmail.com', 'diana19484@hotmail.com', 'Diana Sango', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-osiris1323@yahoo.com', 'osiris1323@yahoo.com', 'Celso Santana Flores', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-denegociosco@gmail.com', 'denegociosco@gmail.com', 'Edgar Ruiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-aleparraduque@gmail.com', 'aleparraduque@gmail.com', 'alejandro parra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-paulaguarnido15@gmail.com', 'paulaguarnido15@gmail.com', 'Paula Guarnido', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-juanpablo.g@solucioneseducativastc.com', 'juanpablo.g@solucioneseducativastc.com', 'Juan Pablo Garzón', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-henryquilind58@gmail.com', 'henryquilind58@gmail.com', 'Henry Quilindo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johan078colombia@hotmail.com', 'johan078colombia@hotmail.com', 'Johan esteban ortiz mesa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jcamiloaga@gmail.com', 'jcamiloaga@gmail.com', 'Jorge Camiloaga', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-dianalucia2021@yahoo.com', 'dianalucia2021@yahoo.com', 'Diana Bueno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jmalvarez@catalizando.com', 'jmalvarez@catalizando.com', 'Juan Manuel', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lauravanessa.marquezc@gmail.com', 'lauravanessa.marquezc@gmail.com', 'Laura Vanessa mARQUEZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rlgladys258@gmail.com', 'rlgladys258@gmail.com', 'Gladys Rodriguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-drgarcia.emprende@gmail.com', 'drgarcia.emprende@gmail.com', 'Alberto Jose Garcia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-tefagomez.art@gmail.com', 'tefagomez.art@gmail.com', 'Estefania Gomez', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-andres7max@gmail.com', 'andres7max@gmail.com', 'Fabian Moreno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ger061136@gmail.com', 'ger061136@gmail.com', 'German Andres Salamanca Medina', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tomassisa72@gmail.com', 'tomassisa72@gmail.com', 'Tomas Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-caprichosspa2019@gmail.com', 'caprichosspa2019@gmail.com', 'Carol Briñez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jorgerodriguezinvestment@gmail.com', 'jorgerodriguezinvestment@gmail.com', 'Jorge Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-josegplazas@gmail.com', 'josegplazas@gmail.com', 'Jose plaza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dropshippingecommercemastery@gmail.com', 'dropshippingecommercemastery@gmail.com', 'Juan camilo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-morenoricardo848@gmail.com', 'morenoricardo848@gmail.com', 'Ricardo moreno', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-oscarmau1@outlook.com', 'oscarmau1@outlook.com', 'Mauricio Mayorga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marthaostios@hotmail.com', 'marthaostios@hotmail.com', 'Yamile ostios', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-impulsa_markting1.0@gmail.com', 'impulsa_markting1.0@gmail.com', 'Ylendi Samboni', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-saavedra.ro75@gmail.com', 'saavedra.ro75@gmail.com', 'Roberto César Saavedra Rengifo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kevinfpa1406@gmail.com', 'kevinfpa1406@gmail.com', 'kevin carmona pajaro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sanchez_laura.h@hotmail.com', 'sanchez_laura.h@hotmail.com', 'Laura Ximena Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-heiber025@gmail.com', 'heiber025@gmail.com', 'Heiber Rojas Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-eventosclubdecampolipangue@gmail.com', 'eventosclubdecampolipangue@gmail.com', 'Paula Quintanilla', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-euvivolavida@hotmail.com', 'euvivolavida@hotmail.com', 'falon murillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lizbethdvand@gmail.com', 'lizbethdvand@gmail.com', 'Lizbeth rativa salas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yurani2102jeronimo@gmail.com', 'yurani2102jeronimo@gmail.com', 'Yurani navarro Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-duqueandrea079@gmail.com', 'duqueandrea079@gmail.com', 'Karina Andrea Duque Suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fabian.gacosta@gmail.com', 'fabian.gacosta@gmail.com', 'Fabian Gutiérrez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danimosidj@gmail.com', 'danimosidj@gmail.com', 'Daniel Mosquera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andres580357@gmail.com', 'andres580357@gmail.com', 'Andres prada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-celecomunica@gmail.com', 'celecomunica@gmail.com', 'Ana Celene Posada Plaza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yuryjimenez@gmail.com', 'yuryjimenez@gmail.com', 'Yury alexandra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-behappynailscl@gmail.com', 'behappynailscl@gmail.com', 'BE HAPPY NAILS SPA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marketingllado@gmail.com', 'marketingllado@gmail.com', 'KAREN LLADO', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-joelmejia708@gmail.com', 'joelmejia708@gmail.com', 'Joel Mejia Parias', 'Reto 15D', 'active', 37.04, 'USD', NOW()),
  ('RETO15D-kristhina39@hotmail.com', 'kristhina39@hotmail.com', 'Ana cristina quintero zarama', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-santicada@gmail.com', 'santicada@gmail.com', 'Santiago cadavid toro Cadavid toro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rauljtorres18@gmail.com', 'rauljtorres18@gmail.com', 'Raúl Torres', 'Reto 15D', 'active', 37.04, 'USD', NOW()),
  ('RETO15D-elpandaaoficial@gmail.com', 'elpandaaoficial@gmail.com', 'Omar Gutierrez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jackfalvarado@gmail.com', 'jackfalvarado@gmail.com', 'Jack Alvarado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-daniela.ortizmedia@gmail.com', 'daniela.ortizmedia@gmail.com', 'Daniela Ortiz Silva', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejandroartis495@gmail.com', 'alejandroartis495@gmail.com', 'Alejandro Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-icristina_perezv@hotmail.com', 'icristina_perezv@hotmail.com', 'Cristina Pérez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-kmbmarketing01@gmail.com', 'kmbmarketing01@gmail.com', 'KAREN MARCELA VEGA BUITRAGO', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-milezagi@gmail.com', 'milezagi@gmail.com', 'Claudia Milena Zapata Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-karolinaochoa.ag@gmail.com', 'karolinaochoa.ag@gmail.com', 'Karolina Ochoa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jdanielrl@gmail.com', 'jdanielrl@gmail.com', 'Daniel Ramirez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lizmanriqueugc@gmail.com', 'lizmanriqueugc@gmail.com', 'Lizeth Manrique Morales', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sandramilenaescobar@hotmail.com', 'sandramilenaescobar@hotmail.com', 'Sandra Escobar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luferpsicologadigital@gmail.com', 'luferpsicologadigital@gmail.com', 'Luisa Fernanda Restrepo Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fitnessjeikmart@gmail.com', 'fitnessjeikmart@gmail.com', 'Jeisson Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-estheladuchesalazar@gmail.com', 'estheladuchesalazar@gmail.com', 'Esthela Duche Salazar', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-coloreartumente@gmail.com', 'coloreartumente@gmail.com', 'Caren Suarez Monsalve', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-unasgotasmagicas@gmail.com', 'unasgotasmagicas@gmail.com', 'Liliana MR', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andresmape1991@gmail.com', 'andresmape1991@gmail.com', 'Fayber Mape', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ovalle.vanessa@gmail.com', 'ovalle.vanessa@gmail.com', 'Vanessa Ovalle', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-clauloc@outlook.com', 'clauloc@outlook.com', 'Claudia Lopez', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-gokuygohan9999@gmail.com', 'gokuygohan9999@gmail.com', 'Daniel Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-memero86@gmail.com', 'memero86@gmail.com', 'Alberto Altamirano', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-luis.feernandog@gmail.com', 'luis.feernandog@gmail.com', 'Luis Fernando Guanga Benavides', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-angelikbp45@gmail.com', 'angelikbp45@gmail.com', 'Angelica Ballesteros', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-claudiaaserna@hotmail.com', 'claudiaaserna@hotmail.com', 'Claudia Veronica Mendivil Serna', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-contactomagentaxv@gmail.com', 'contactomagentaxv@gmail.com', 'Viridiana Andrés Jiménez', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-mkarmengl@hotmail.com', 'mkarmengl@hotmail.com', 'Marycarmen Gutiérrez López', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-cindysilvajesus8@gmail.com', 'cindysilvajesus8@gmail.com', 'Cindy Silva', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-carlosbuitrago1992@hotmail.com', 'carlosbuitrago1992@hotmail.com', 'Carlos Buitrago', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-kaorimurasaki205@gmail.com', 'kaorimurasaki205@gmail.com', 'Kaori Murasaki', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-edwar31mejia@gmail.com', 'edwar31mejia@gmail.com', 'Edwar alexander mejia cano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lejarazu86@gmail.com', 'lejarazu86@gmail.com', 'Maricarmen Lejarazu', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maymont6212@gmail.com', 'maymont6212@gmail.com', 'Mayra Velázquez', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-gifagomu1986@gmail.com', 'gifagomu1986@gmail.com', 'Gina Farley Godoy Murillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-johamarketing@gmail.com', 'johamarketing@gmail.com', 'Joha Enciso Gutiérrez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-cohencaceres@gmail.com', 'cohencaceres@gmail.com', 'Maria Concepcion Gaona', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lanishellw@hotmail.com', 'lanishellw@hotmail.com', 'Lanishell Wong', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-narusanarusewawa@gmail.com', 'narusanarusewawa@gmail.com', 'Diana Verenice Cervantes Garcia', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-marisolenriquez0101@gmail.com', 'marisolenriquez0101@gmail.com', 'Marisol Enriquez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-carlosballesteros777@hotmail.com', 'carlosballesteros777@hotmail.com', 'Carlos ballesteros', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cris_david97@hotmail.com', 'cris_david97@hotmail.com', 'Cristopher Muzzio', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-creativo@erickraw.page', 'creativo@erickraw.page', 'Erick torres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dianajarangoa@gmail.com', 'dianajarangoa@gmail.com', 'Diana Jaramillo A', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-pilar.sanchez1919@gmail.com', 'pilar.sanchez1919@gmail.com', 'Pilar Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alfredodelcastillo511@gmail.com', 'alfredodelcastillo511@gmail.com', 'Alfredo del Castillo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-rodrigoospino@hotmail.com', 'rodrigoospino@hotmail.com', 'Rodrigo ospino', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tatianavargas026@gmail.com', 'tatianavargas026@gmail.com', 'Tatiana Vargas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mercadeoglobalvitality@gmail.com', 'mercadeoglobalvitality@gmail.com', 'Diego Restrepo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vibesbgta@gmail.com', 'vibesbgta@gmail.com', 'Cristian Ladino Ojeda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-maikolquintero20@gmail.com', 'maikolquintero20@gmail.com', 'Steven Quintero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-toutsurlemarketingdereseau@gmail.com', 'toutsurlemarketingdereseau@gmail.com', 'Mathieu Remi', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-lauravierab@gmail.com', 'lauravierab@gmail.com', 'laura viera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-erickarnulfo2@gmail.com', 'erickarnulfo2@gmail.com', 'Heriberto Arnulfo jose', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-lisandrapi1986@gmail.com', 'lisandrapi1986@gmail.com', 'Lisandra Pi Fuentes', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ovejares@gmail.com', 'ovejares@gmail.com', 'Oscar vejares olivera', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-infodosantosfc@gmail.com', 'infodosantosfc@gmail.com', 'Diego Hernan Murillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-edgar.garcia.rsvp@gmail.com', 'edgar.garcia.rsvp@gmail.com', 'Edgar García', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-rlopezp.ambassador@gmail.com', 'rlopezp.ambassador@gmail.com', 'Vanessa lopez', 'Reto 15D', 'active', 37.37, 'USD', NOW()),
  ('RETO15D-maitevega758@gmail.com', 'maitevega758@gmail.com', 'Pamela Bobadilla', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-palomacm@me.com', 'palomacm@me.com', 'Paloma Castillo', 'Reto 15D', 'active', 36.95, 'USD', NOW()),
  ('RETO15D-yeimybm@hotmail.com', 'yeimybm@hotmail.com', 'Yeimy botero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-glenda.carranza@gmail.com', 'glenda.carranza@gmail.com', 'Glenda Carranza Rodriguez', 'Reto 15D', 'active', 36.95, 'USD', NOW()),
  ('RETO15D-romor.oficial@gmail.com', 'romor.oficial@gmail.com', 'Patricio Jesús Román Morgado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jennyvivianamartinez1987@gmail.com', 'jennyvivianamartinez1987@gmail.com', 'Jenny viviana', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-aguilerabrito.beatriz@gmail.com', 'aguilerabrito.beatriz@gmail.com', 'Beatriz Aguilera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alexipatino78@gmail.com', 'alexipatino78@gmail.com', 'Alexis Patiño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lozpatricia@gmail.com', 'lozpatricia@gmail.com', 'Patricia Lozano', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bitacoraroundtrip@gmail.com', 'bitacoraroundtrip@gmail.com', 'Aleimar Rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-manuelavilla06@hotmail.com', 'manuelavilla06@hotmail.com', 'Manuela Villa', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-delvinquispem@gmail.com', 'delvinquispem@gmail.com', 'Delvin Quispe', 'Reto 15D', 'active', 37.37, 'USD', NOW()),
  ('RETO15D-eligilram@gmail.com', 'eligilram@gmail.com', 'Elizabeth Gil Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lic.victorjavier@hotmail.com', 'lic.victorjavier@hotmail.com', 'Victor javier Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rocio.astocaza@gmail.com', 'rocio.astocaza@gmail.com', 'Rocio Astocaza Flores', 'Reto 15D', 'active', 37.25, 'USD', NOW()),
  ('RETO15D-saligore@hotmail.com', 'saligore@hotmail.com', 'Sandra Liliana Gonzalez Rendon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rickdelarosa@outlook.com', 'rickdelarosa@outlook.com', 'Rick de la R', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rivera172050@gmail.com', 'rivera172050@gmail.com', 'Constantino Rivera Acevedo', 'Reto 15D', 'active', 37.25, 'USD', NOW()),
  ('RETO15D-leidyquicenoc@gmail.com', 'leidyquicenoc@gmail.com', 'Leidy Quiceno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-manuelyongb@hotmail.com', 'manuelyongb@hotmail.com', 'Manuel Yong Betancourt', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-depositosonline24@gmail.com', 'depositosonline24@gmail.com', 'Jesus Segura', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-pariasrealtor@gmail.com', 'pariasrealtor@gmail.com', 'Paula arias', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-stellakin69@gmail.com', 'stellakin69@gmail.com', 'Stella Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-charlesbarrera@hotmail.es', 'charlesbarrera@hotmail.es', 'Charles Andres Barrera Giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-edwinrodriguezm777@gmail.com', 'edwinrodriguezm777@gmail.com', 'Edwin Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-marlloryvd94@outlook.com', 'marlloryvd94@outlook.com', 'Marllory Carolina Venegas Domínguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-bellocabreran@gmail.com', 'bellocabreran@gmail.com', 'Naomi Bello', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-julianlandazabal01@gmail.com', 'julianlandazabal01@gmail.com', 'Gerson Julián  Landazabal Rodríguez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diazconsultorescontables@gmail.com', 'diazconsultorescontables@gmail.com', 'Victoria Díaz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-daisymacmontoyav@gmail.com', 'daisymacmontoyav@gmail.com', 'Daisy Montoya Valencia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leowave97@hotmail.com', 'leowave97@hotmail.com', 'Leonel Ledesma', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-castrorubiela1982@gmail.com', 'castrorubiela1982@gmail.com', 'Rubiela Castro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yeapare@gmail.com', 'yeapare@gmail.com', 'YEFFER ARLEY PARRA RENTERIA', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-silviagonzalez.mkt@gmail.com', 'silviagonzalez.mkt@gmail.com', 'Silvia González', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-rosendobig2016@gmail.com', 'rosendobig2016@gmail.com', 'Rosendo Argote', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-engyyes@hotmail.com', 'engyyes@hotmail.com', 'Engie Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-javibillions@gmail.com', 'javibillions@gmail.com', 'Juan Serrano', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-nataorma.30@gmail.com', 'nataorma.30@gmail.com', 'Natalia Ortiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dmarcemont@hotmail.com', 'dmarcemont@hotmail.com', 'Marcela Montenegro Robayo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-daniycn13@gmail.com', 'daniycn13@gmail.com', 'Daniela Castillo', 'Reto 15D', 'active', 37.28, 'USD', NOW()),
  ('RETO15D-alexpuentess10@gmail.com', 'alexpuentess10@gmail.com', 'Alex Puentes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-albeiroosorio182@gmail.com', 'albeiroosorio182@gmail.com', 'Albeiro Osorio Restrepo', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-luismotacreativo@gmail.com', 'luismotacreativo@gmail.com', 'Luis Fernando Mota', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jesika.giraldo@gmail.com', 'jesika.giraldo@gmail.com', 'Jessica giraldo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-eriyul21@hotmail.com', 'eriyul21@hotmail.com', 'Erika Ordoñez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yimarire_03@hotmail.com', 'yimarire_03@hotmail.com', 'yina marcela rios', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-estebanbedoya07@gmail.com', 'estebanbedoya07@gmail.com', 'Esteban Bedoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mariacamiladuque626@hotmail.com', 'mariacamiladuque626@hotmail.com', 'Maria camila duque', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-glenisyc1985@gmail.com', 'glenisyc1985@gmail.com', 'Glenis Camacho', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gustavoadolfof@yahoo.com', 'gustavoadolfof@yahoo.com', 'Gustavo Adolfo Fonseca S.', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-moni.mateus@hotmail.com', 'moni.mateus@hotmail.com', 'Mónica Mateus Martinez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-arlynxm3@gmail.com', 'arlynxm3@gmail.com', 'Arlyn Mendoza', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-varolas@hotmail.com', 'varolas@hotmail.com', 'Alvaro Estrada', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-elianats101995@hotmail.com', 'elianats101995@hotmail.com', 'Eliana Andrea Torres Sierra', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andrepadilla_dg@hotmail.es', 'andrepadilla_dg@hotmail.es', 'Andrea Padilla Borja', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-digitizeteam@gmail.com', 'digitizeteam@gmail.com', 'NEIBA CORDERO', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jimmyferlissi@gmail.com', 'jimmyferlissi@gmail.com', 'Jimmy ferlissi', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-chenegrocr@gmail.com', 'chenegrocr@gmail.com', 'Rebeca Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-letsanva@yahoo.com.mx', 'letsanva@yahoo.com.mx', 'LETICIA SANCHEZ VAZQUEZ', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-voittogroup.az@gmail.com', 'voittogroup.az@gmail.com', 'Jesus gonzalez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-josmanleon2023@gmail.com', 'josmanleon2023@gmail.com', 'Josman Leon', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-karolinatrochez@gmail.com', 'karolinatrochez@gmail.com', 'Caro Trochez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-andreapinzonq@gmail.com', 'andreapinzonq@gmail.com', 'Andrea Pinzon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-l.ortizcarvacho@gmail.com', 'l.ortizcarvacho@gmail.com', 'Luis Ortiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-edgar5_14@hotmail.com', 'edgar5_14@hotmail.com', 'Edgar Quispe Arapa', 'Reto 15D', 'active', 37.41, 'USD', NOW()),
  ('RETO15D-dannysase123@gmail.com', 'dannysase123@gmail.com', 'Danny Saavedra', 'Reto 15D', 'active', 37.41, 'USD', NOW()),
  ('RETO15D-soyemilyarvi@gmail.com', 'soyemilyarvi@gmail.com', 'Emilia ariza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-kurtgajardo@gmail.com', 'kurtgajardo@gmail.com', 'Kurt Gajardo Morris', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diegoriascos16@gmail.com', 'diegoriascos16@gmail.com', 'Diego Fernando Riascos Pino', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-creamosvalor1@gmail.com', 'creamosvalor1@gmail.com', 'Johanna Ramirez Castro', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hidelacruz@yahoo.com', 'hidelacruz@yahoo.com', 'Hilcia Macias', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-imperiostours@gmail.com', 'imperiostours@gmail.com', 'Hector Fabio Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-geekjfredo@gmail.com', 'geekjfredo@gmail.com', 'jhon fredy castaño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-andreavelascofuxion@gmail.com', 'andreavelascofuxion@gmail.com', 'ANDREA VELASCO RIOS', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-soylauhuerfano@gmail.com', 'soylauhuerfano@gmail.com', 'Laura Carolina Huerfano Calderon', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-mcsaleos@gmail.com', 'mcsaleos@gmail.com', 'Mayra Leos', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-geral99jll@gmail.com', 'geral99jll@gmail.com', 'Geraldine Juarez', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-gonzalez_o_alejandro@hotmail.com', 'gonzalez_o_alejandro@hotmail.com', 'Michael Alejandro Gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lauralorena99v@gmail.com', 'lauralorena99v@gmail.com', 'Laura Lorena Romero Viafara', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-isabelpesantez.a@gmail.com', 'isabelpesantez.a@gmail.com', 'Isabel Pesántez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-sosa-roa@hotmail.com', 'sosa-roa@hotmail.com', 'Mabel Jaramillo Sosa', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-danipiercing.22@gmail.com', 'danipiercing.22@gmail.com', 'Sirley Romero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-elsybarrero@gmail.com', 'elsybarrero@gmail.com', 'Elsy Ruth Barrero V', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-ginistoro1@gmail.com', 'ginistoro1@gmail.com', 'Marcela Toro', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-diego.palacio10@hotmail.com', 'diego.palacio10@hotmail.com', 'Diego palacio', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-luispo14@hotmail.com', 'luispo14@hotmail.com', 'Jorge Parra', 'Reto 15D', 'active', 36.56, 'USD', NOW()),
  ('RETO15D-paola3qui@icloud.com', 'paola3qui@icloud.com', 'Paola Quiceno', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-manu.rojas.rios@gmail.com', 'manu.rojas.rios@gmail.com', 'Manuela Rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-leidyjohana1003@hotmail.com', 'leidyjohana1003@hotmail.com', 'Leidy Garcia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-camilo-sanchez@hotmail.com', 'camilo-sanchez@hotmail.com', 'Camilo Sanchez Castaño', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lexmarketer2025@gmail.com', 'lexmarketer2025@gmail.com', 'Angel iram Martinez Amaro', 'Reto 15D', 'active', 36.95, 'USD', NOW()),
  ('RETO15D-malun1694@hotmail.com', 'malun1694@hotmail.com', 'Marlon esnayder izquierdo alvarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-davidduquecastillo@gmail.com', 'davidduquecastillo@gmail.com', 'Cristhian David duque Castillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jhonalexander2815@gmail.com', 'jhonalexander2815@gmail.com', 'Jhon Alexander bocanegra Agudelo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alfonsoorozcoo@hotmail.com', 'alfonsoorozcoo@hotmail.com', 'Alfonso orozco', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-joyasconexion.japamala@gmail.com', 'joyasconexion.japamala@gmail.com', 'jessica alexandra bermudez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jpbravoa.jpb@gmail.com', 'jpbravoa.jpb@gmail.com', 'Juan pablo Bravo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-catalinach05@gmail.com', 'catalinach05@gmail.com', 'Catalina Chaguala Sanchez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gallegosbruno96@gmail.com', 'gallegosbruno96@gmail.com', 'Bruno Gallegos', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-ramirez.salo08@gmail.com', 'ramirez.salo08@gmail.com', 'SALOMON MORFIN', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-maryvit2601@gmail.com', 'maryvit2601@gmail.com', 'María del Carmen Olivares Vite', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-madretierranatural@hotmail.com', 'madretierranatural@hotmail.com', 'carolina robledo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rosabelrinconhernandez@gmail.com', 'rosabelrinconhernandez@gmail.com', 'Rosabel Rincon Hernandez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-soygusmasterdigital@gmail.com', 'soygusmasterdigital@gmail.com', 'Gustavo Lopez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-avanta.col@gmail.com', 'avanta.col@gmail.com', 'Miguel muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-celso@clickdesignmedia.com', 'celso@clickdesignmedia.com', 'Celso Azamar', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-vasquezgomezjenifer@gmail.com', 'vasquezgomezjenifer@gmail.com', 'Jenifer Vasquez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-soporteyeimerrestrepo@gmail.com', 'soporteyeimerrestrepo@gmail.com', 'Yeimer Restrepo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dayro.bohorquez@gmail.com', 'dayro.bohorquez@gmail.com', 'Dayro Humberto Bohórquez Escobar', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-jmbecerrar@icloud.com', 'jmbecerrar@icloud.com', 'José Manuel Becerra Romero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-danielapsepulveda@gmail.com', 'danielapsepulveda@gmail.com', 'Daniela Pino Sepúlveda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-infrarojoestudio@gmail.com', 'infrarojoestudio@gmail.com', 'Deyvid Montoya', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-durdely@gmail.com', 'durdely@gmail.com', 'Durdely Ramirez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-svascoca@gmail.com', 'svascoca@gmail.com', 'Sara Vasco Cadavid', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-smosqueramazud@gmail.com', 'smosqueramazud@gmail.com', 'Sebastian mosquera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-prolims_eat1123@hotmail.com', 'prolims_eat1123@hotmail.com', 'Erick Añasco', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-valeriavalencia9635@gmail.com', 'valeriavalencia9635@gmail.com', 'Valeria Valencia Muñoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jhonathanjimenezg@gmail.com', 'jhonathanjimenezg@gmail.com', 'Jhonatan Jiménez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ricardocardonaafiliado@gmail.com', 'ricardocardonaafiliado@gmail.com', 'Ricardo Cardona', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-pauendec@gmail.com', 'pauendec@gmail.com', 'Paulina Enderica', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angelita1985caicedo@hotmail.com', 'angelita1985caicedo@hotmail.com', 'Bernardo caicedo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-daymara.aroon.28@gmail.com', 'daymara.aroon.28@gmail.com', 'Daymara Rivas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carocboteroo@gmail.com', 'carocboteroo@gmail.com', 'Carolina C', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carlospty7@gmail.com', 'carlospty7@gmail.com', 'Carlos Santamaria', 'Reto 15D', 'active', 38.87, 'USD', NOW()),
  ('RETO15D-edilmadeb@hotmail.com', 'edilmadeb@hotmail.com', 'Edilma de Barrera', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jdelcastillo18@gmail.com', 'jdelcastillo18@gmail.com', 'Tienda Galeras', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-trainer@paolapaico.com', 'trainer@paolapaico.com', 'Paola Paico', 'Reto 15D', 'active', 37.04, 'USD', NOW()),
  ('RETO15D-ngallegolondono@gmail.com', 'ngallegolondono@gmail.com', 'Natalia Gallego', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sbaquero555@gmail.com', 'sbaquero555@gmail.com', 'Sandra Nieto', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alda.perez37@hotmail.com', 'alda.perez37@hotmail.com', 'Aldair Perez Ayala', 'Reto 15D', 'active', 37.04, 'USD', NOW()),
  ('RETO15D-emprendo.mkt90@gmail.com', 'emprendo.mkt90@gmail.com', 'Catherine Díaz', 'Reto 15D', 'active', 37.04, 'USD', NOW()),
  ('RETO15D-brandonsocampo@gmail.com', 'brandonsocampo@gmail.com', 'Brandon Ocampo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-hans@robles.com.ec', 'hans@robles.com.ec', 'Hans Robles García', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-edgar7mauro@hotmail.com', 'edgar7mauro@hotmail.com', 'Edgar guerra', 'Reto 15D', 'active', 37.04, 'USD', NOW()),
  ('RETO15D-kleberhoy@outlook.com', 'kleberhoy@outlook.com', 'kleber quelal', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-marianaherrera460@gmail.com', 'marianaherrera460@gmail.com', 'Mariana Herrera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diegopg816@gmail.com', 'diegopg816@gmail.com', 'Diego Andres Patiño Galindo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jhonyadelgadof@gmail.com', 'jhonyadelgadof@gmail.com', 'Jhony Delgado Florez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rossinardzconsultoria@gmail.com', 'rossinardzconsultoria@gmail.com', 'Rossina Rodriguez', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-luisamlopera@gmail.com', 'luisamlopera@gmail.com', 'Luisa Lopera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juanyvillalbaendigital@gmail.com', 'juanyvillalbaendigital@gmail.com', 'Juany Villalba', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-tatyspretty@hotmail.com', 'tatyspretty@hotmail.com', 'Tatiana Romero', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ana.gomez@jeanscolombianos.com', 'ana.gomez@jeanscolombianos.com', 'Ana Maria Gomez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-valstudiocreative@gmail.com', 'valstudiocreative@gmail.com', 'Valeria rodas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-samuelboca.111@gmail.com', 'samuelboca.111@gmail.com', 'Samuel bocanumenth', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-dianadelgadodigital@gmail.com', 'dianadelgadodigital@gmail.com', 'Diana Delgado', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-raule0997@gmail.com', 'raule0997@gmail.com', 'Raul Esteban Castaño Salazar', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-enriquevillalobosr@gmail.com', 'enriquevillalobosr@gmail.com', 'Enrique Villalobos Rodriguez', 'Reto 15D', 'active', 36.95, 'USD', NOW()),
  ('RETO15D-pablostefanodg@gmail.com', 'pablostefanodg@gmail.com', 'PABLO DIAZ', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-madelenyy21@gmail.com', 'madelenyy21@gmail.com', 'Madeleny Mejia', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-diestros1@gmail.com', 'diestros1@gmail.com', 'Alvaro Enrique Osorio García', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-linatamayo@remaxm.net', 'linatamayo@remaxm.net', 'Lina Tamayo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-esteban_jz@outlook.es', 'esteban_jz@outlook.es', 'Esteban Jaramillo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gonzalezmlaura@hotmail.com', 'gonzalezmlaura@hotmail.com', 'Laura Marina González', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alejandra.frost.a@gmail.com', 'alejandra.frost.a@gmail.com', 'Alejandra frost', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gustavosorio1020@gmail.com', 'gustavosorio1020@gmail.com', 'Gustavo Osorio', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alexanderdomenech.b@gmail.com', 'alexanderdomenech.b@gmail.com', 'Alex Dom', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-aizajar@gmail.com', 'aizajar@gmail.com', 'Genesis Bracho', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-golgag@yahoo.com', 'golgag@yahoo.com', 'Olga Gonzalez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ceciliaorellana27@gmail.com', 'ceciliaorellana27@gmail.com', 'Cecilia Orellana', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-garpchile@gmail.com', 'garpchile@gmail.com', 'Gabriela Rojas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jdjcoronado@yahoo.es', 'jdjcoronado@yahoo.es', 'José de Jesus', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sandrasantamariacoach@gmail.com', 'sandrasantamariacoach@gmail.com', 'Sandra Milena Santamaria', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jucamilo15@hotmail.com', 'jucamilo15@hotmail.com', 'Juan Camilo Beltran Ayala', 'Reto 15D', 'active', 37.52, 'USD', NOW()),
  ('RETO15D-karla8383carrillo@yahoo.com', 'karla8383carrillo@yahoo.com', 'Karla Carrillo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-marianelacardenasv@yahoo.es', 'marianelacardenasv@yahoo.es', 'Marianela Cárdenas', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bibikjeldsen@gmail.com', 'bibikjeldsen@gmail.com', 'Viviana Kjeldsen', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-carloscamacho.doc@gmail.com', 'carloscamacho.doc@gmail.com', 'carlos camacho', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-john.loaiza.guerra@gmail.com', 'john.loaiza.guerra@gmail.com', 'John Loaiza', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lianariosh@gmail.com', 'lianariosh@gmail.com', 'Liana Rios', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lusuarez.med@gmail.com', 'lusuarez.med@gmail.com', 'Luisa suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yamilok-13@hotmail.com', 'yamilok-13@hotmail.com', 'Yamile Cortes', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jaimeuriasmkt@gmail.com', 'jaimeuriasmkt@gmail.com', 'Jaime Urías', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-vanesa@mentalidadinquebrantable.com', 'vanesa@mentalidadinquebrantable.com', 'Vanesa Fernández mejido', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-danielaom31.dom@gmail.com', 'danielaom31.dom@gmail.com', 'Daniela Ospina Marulanda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cesargarcia72012@hotmail.com', 'cesargarcia72012@hotmail.com', 'CESAR AUGUSTO GARCIA PEREZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-geovanylondono1@hotmail.com', 'geovanylondono1@hotmail.com', 'Geovani Londoño', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-vivienvacafashion@gmail.com', 'vivienvacafashion@gmail.com', 'Vivien vaca', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-enrique.isarra@gmail.com', 'enrique.isarra@gmail.com', 'Enrique Isarra', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-crksoritor@gmail.com', 'crksoritor@gmail.com', 'Usiel Rojas', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-arqous.info@gmail.com', 'arqous.info@gmail.com', 'Arqous Corp', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-michaelcruzhomes@gmail.com', 'michaelcruzhomes@gmail.com', 'Michael Cruz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mitchelckimberlyn@gmail.com', 'mitchelckimberlyn@gmail.com', 'Mitchel cedeño', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-tlandetta@gmail.com', 'tlandetta@gmail.com', 'Tatiana landeta', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-norly.cabrera@riverdistrict14.com', 'norly.cabrera@riverdistrict14.com', 'NORLY CABRERA', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-dentalclubcenter@gmail.com', 'dentalclubcenter@gmail.com', 'Octavio Torrecilla', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-yosoymafe@gmail.com', 'yosoymafe@gmail.com', 'Maria Torres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-finanzasesumer@gmail.com', 'finanzasesumer@gmail.com', 'Alonso Zuluaga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carlosdiego8@yahoo.com.co', 'carlosdiego8@yahoo.com.co', 'Carlos ortiz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-joseangelsantosgaitan@gmail.com', 'joseangelsantosgaitan@gmail.com', 'Jose Angel Santos Gaitan', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-darias.sepulveda@gmail.com', 'darias.sepulveda@gmail.com', 'David Arias Sepulveda', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-ncruz02@gmail.com', 'ncruz02@gmail.com', 'Norberto Cruz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-henryalbertocr@gmail.com', 'henryalbertocr@gmail.com', 'henry castañeda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ljohanaosorio@gmail.com', 'ljohanaosorio@gmail.com', 'Johana Osorio', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lina.de.do@gmail.com', 'lina.de.do@gmail.com', 'Lina Denis', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-info@amhpartnersllc.com', 'info@amhpartnersllc.com', 'Alfrdo Montiel', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mariapaula@qhubocars.com', 'mariapaula@qhubocars.com', 'Maria Quintero', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-claraliagutierrez@gmail.com', 'claraliagutierrez@gmail.com', 'Clara Lia Gutierrez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-estevancartagena@gmail.com', 'estevancartagena@gmail.com', 'Carlos Esteban Martinez Cartagena', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-villanica@gmail.com', 'villanica@gmail.com', 'Veronica Arango', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-liizlacruz@gmail.com', 'liizlacruz@gmail.com', 'Liz Lacruz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bexterfilms1518@gmail.com', 'bexterfilms1518@gmail.com', 'Dilan Alejandro Morales Vélez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-rebecademonzon@yahoo.com.mx', 'rebecademonzon@yahoo.com.mx', 'Rebeca Polá de Monzón', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-klaudyaportes@gmail.com', 'klaudyaportes@gmail.com', 'Claudia romero', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-zullihoyod@gmail.com', 'zullihoyod@gmail.com', 'Zully Hoyos', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-molinafabianarq@gmail.com', 'molinafabianarq@gmail.com', 'Erison Ceballos', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-hallertirado@gmail.com', 'hallertirado@gmail.com', 'John Martin', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-billonariolatino21k@gmail.com', 'billonariolatino21k@gmail.com', 'Jota lopez', 'Reto 15D', 'active', 37.47, 'USD', NOW()),
  ('RETO15D-alejandrolorenzl@hotmail.com', 'alejandrolorenzl@hotmail.com', 'Cesar Lobo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-adnfitnessjujuy@gmail.com', 'adnfitnessjujuy@gmail.com', 'MATIAS GERARDO PEREZ', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-dianamarcelarias@gmail.com', 'dianamarcelarias@gmail.com', 'Diana marcela arias', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-integralbodybeauty@gmail.com', 'integralbodybeauty@gmail.com', 'Yolanda Mendoza', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-danycaceresagnello@gmail.com', 'danycaceresagnello@gmail.com', 'Dany Caceres', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-yenit_27@hotmail.com', 'yenit_27@hotmail.com', 'Juliana Ramirez', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-ravellanedam@gmail.com', 'ravellanedam@gmail.com', 'Ronald Avellaneda Montenegro', 'Reto 15D', 'active', 37.47, 'USD', NOW()),
  ('RETO15D-garciavasquezgabriel@gmail.com', 'garciavasquezgabriel@gmail.com', 'Gabriel Garcia Vásquez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-natalia03625@gmail.com', 'natalia03625@gmail.com', 'Natalia Arboleda', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cristiangzesc@gmail.com', 'cristiangzesc@gmail.com', 'CRISTIAN GONZALEZ', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-acgamboan@gmail.com', 'acgamboan@gmail.com', 'Aura Gamboa', 'Reto 15D', 'active', 36.95, 'USD', NOW()),
  ('RETO15D-colombianaautosales@gmail.com', 'colombianaautosales@gmail.com', 'Leidy Quiroga', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-sicaagustin2000@gmail.com', 'sicaagustin2000@gmail.com', 'Agustin Sica', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-isabelsarca@gmail.com', 'isabelsarca@gmail.com', 'diego fernando idarraga', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-juanybric@msn.com', 'juanybric@msn.com', 'Juany Bric', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-melanievela43@gmail.com', 'melanievela43@gmail.com', 'Melania Velasquez', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-nataliamorenocalle@gmail.com', 'nataliamorenocalle@gmail.com', 'Natalia Moreno', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-julian.munozcruz@gmail.com', 'julian.munozcruz@gmail.com', 'Julian Andrés munoz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-javier.vasquezpalacios@hotmail.com', 'javier.vasquezpalacios@hotmail.com', 'Javier Vásquez Palacios', 'Reto 15D', 'active', 37.06, 'USD', NOW()),
  ('RETO15D-lidumonasterio11@gmail.com', 'lidumonasterio11@gmail.com', 'Odra Velásquez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-agenciainmobiliariacancun@gmail.com', 'agenciainmobiliariacancun@gmail.com', 'Iveth Morales', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-fredy.gamarra.z@gmail.com', 'fredy.gamarra.z@gmail.com', 'Fredy Gamarra Zárate', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-aponteyaz201701@gmail.com', 'aponteyaz201701@gmail.com', 'Yasmin Aponte', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-sharikdnanda456@gmail.com', 'sharikdnanda456@gmail.com', 'Sharikd Esteban', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ivonnealfonso28@gmail.com', 'ivonnealfonso28@gmail.com', 'Ivonne Alfonso', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-cajitamelosa@gmail.com', 'cajitamelosa@gmail.com', 'Johana Mosquera', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lesanabriaochoa@gmail.com', 'lesanabriaochoa@gmail.com', 'Luz Estefania Sanabria', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fabiansuperseya@gmail.com', 'fabiansuperseya@gmail.com', 'Fabian Monroy', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-alexander.koteskys@gmail.com', 'alexander.koteskys@gmail.com', 'Alexander kotesky', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jom7215jom@gmail.com', 'jom7215jom@gmail.com', 'Judith Orosco', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-karenarodriguezg@gmail.com', 'karenarodriguezg@gmail.com', 'Karen rodriguez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-alexafreitez27@gmail.com', 'alexafreitez27@gmail.com', 'Alexa Freitez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-florencia@inuitlab.com', 'florencia@inuitlab.com', 'Florencia Sandjian', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-jose.viropa@gmail.com', 'jose.viropa@gmail.com', 'Jose Romero Paredes', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-rayquipa@hotmail.com', 'rayquipa@hotmail.com', 'Rocio ayquipa', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-aryamfrigia@gmail.com', 'aryamfrigia@gmail.com', 'Adriana Fdez', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-mariaalexandragk@gmail.com', 'mariaalexandragk@gmail.com', 'Maria Alexandra Alexandra', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-nellyfloresegocheaga@gmail.com', 'nellyfloresegocheaga@gmail.com', 'Nelly Sevelyn Flores Egocheaga', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-majopillo09@gmail.com', 'majopillo09@gmail.com', 'Angélica urrea', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-redondo.paola@gmail.com', 'redondo.paola@gmail.com', 'Paola Redondo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-aylin.alfaror@gmail.com', 'aylin.alfaror@gmail.com', 'Aylin Guadalupe Alfaro Reyes', 'Reto 15D', 'active', 36.99, 'USD', NOW()),
  ('RETO15D-denisseortiz35@gmail.com', 'denisseortiz35@gmail.com', 'Denisse Ortiz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-imjoyasplata@gmail.com', 'imjoyasplata@gmail.com', 'Maximiliano Diez', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-paosinrumbo@gmail.com', 'paosinrumbo@gmail.com', 'Paola Sáenz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-lourdesvrealtor@gmail.com', 'lourdesvrealtor@gmail.com', 'Lourdes Valladares', 'Reto 15D', 'active', 37.05, 'USD', NOW()),
  ('RETO15D-wendybiflo@hotmail.com', 'wendybiflo@hotmail.com', 'Wendy Villamil florez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-lu2montene@gmail.com', 'lu2montene@gmail.com', 'Luis Montenegro', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-edgarfaviani@gmail.com', 'edgarfaviani@gmail.com', 'Edgar Faviani', 'Reto 15D', 'active', 37.03, 'USD', NOW()),
  ('RETO15D-mariaelcycardozomartinez@gmail.com', 'mariaelcycardozomartinez@gmail.com', 'Maria Elcy Cardozo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-natalycreativa@hotmail.com', 'natalycreativa@hotmail.com', 'Nataly Sierra Clavijo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-carfel42@hotmail.com', 'carfel42@hotmail.com', 'Carlos Vaca', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-angie.silva.9807@gmail.com', 'angie.silva.9807@gmail.com', 'angie camila silva jáuregui', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mailithbustamante@gmail.com', 'mailithbustamante@gmail.com', 'Mailyth mileth', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-saratuxtra@gmail.com', 'saratuxtra@gmail.com', 'Sara Ibanez', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-erita28_9@hotmail.com', 'erita28_9@hotmail.com', 'Erika Guerrero', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-vivi.galindo83@outlook.com', 'vivi.galindo83@outlook.com', 'Olga Viviana Galindo Angulo', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-slpconstruction81@gmail.com', 'slpconstruction81@gmail.com', 'Pablo Guevara', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-veronicacuartassuarez@gmail.com', 'veronicacuartassuarez@gmail.com', 'Veronica Cuartas Suarez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-joanna_amaral@live.com', 'joanna_amaral@live.com', 'Joana Amaral', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-khatebolivarugc@gmail.com', 'khatebolivarugc@gmail.com', 'Khaterine Bolívar Quiroz', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-angie_0231@hotmail.com', 'angie_0231@hotmail.com', 'Angie Johanna Parra Niño', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-claudiadelahoz@hotmail.com', 'claudiadelahoz@hotmail.com', 'de la Hoz, Claudia Haydee', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-jimematacin@gmail.com', 'jimematacin@gmail.com', 'Jimena Matacin', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-paoaristizabal1@hotmail.com', 'paoaristizabal1@hotmail.com', 'Paola Aristizábal Aristizabal', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-mcamilams2022@gmail.com', 'mcamilams2022@gmail.com', 'Camila Marquez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rosarioochoa1102@gmail.com', 'rosarioochoa1102@gmail.com', 'Rosario Ochoa', 'Reto 15D', 'active', 36.92, 'USD', NOW()),
  ('RETO15D-dperfectos@hotmail.com', 'dperfectos@hotmail.com', 'Delma Perfecto', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-gilberto@gobemax.com', 'gilberto@gobemax.com', 'Ronald G Laparra', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-c.gerardomontalvo@gmail.com', 'c.gerardomontalvo@gmail.com', 'Gerardo Montalvo Sanchez', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-spalzate@gmail.com', 'spalzate@gmail.com', 'Sandra Alzate', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-gsefair@gmail.com', 'gsefair@gmail.com', 'Georges Sefair', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-crew@clandestinostudio.com', 'crew@clandestinostudio.com', 'Clamdestino studio', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-di.chiriboga@gmail.com', 'di.chiriboga@gmail.com', 'Diana Chiriboga', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-mauricioorjuela18@gmail.com', 'mauricioorjuela18@gmail.com', 'Mauricio orjuela', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-morios.oficial@gmail.com', 'morios.oficial@gmail.com', 'Alejandra Morón', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-fandosvictoria@gmail.com', 'fandosvictoria@gmail.com', 'Victoria luz Fandos', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-3amultiservicesllc@gmail.com', '3amultiservicesllc@gmail.com', 'Angie Diaz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-formacionfuturoglobal@gmail.com', 'formacionfuturoglobal@gmail.com', 'Daniel Ruiz', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-johan.fuen@gmail.com', 'johan.fuen@gmail.com', 'JOHAN FUENTES LOZANO', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bronsillon90@hotmail.com', 'bronsillon90@hotmail.com', 'Carlos Garcia', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-graphic.halland@gmail.com', 'graphic.halland@gmail.com', 'HALLAND HERNANDEZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-bernallcarloss21@gmail.com', 'bernallcarloss21@gmail.com', 'Juan Carlos', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-nydia_beltran@yahoo.com.mx', 'nydia_beltran@yahoo.com.mx', 'Nydia Beltran', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-mariaaquije35@gmail.com', 'mariaaquije35@gmail.com', 'María Aquije', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-pau.cbe2530@gmail.com', 'pau.cbe2530@gmail.com', 'Paula bardalez', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-luigi.alcalde@gmail.com', 'luigi.alcalde@gmail.com', 'Luigi Alcalde', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-carlosjosuemz8@gmail.com', 'carlosjosuemz8@gmail.com', 'Carlos Marquez', 'Reto 15D', 'active', 37.01, 'USD', NOW()),
  ('RETO15D-karennataliaflorez457@gmail.com', 'karennataliaflorez457@gmail.com', 'KAREN NATALIA FLOREZ', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-ramvaleria61@gmail.com', 'ramvaleria61@gmail.com', 'Valeria Estefania Ramirez Duarte', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-aldo@aldocivico.com', 'aldo@aldocivico.com', 'Aldo Civico', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-janissantaella@yahoo.com', 'janissantaella@yahoo.com', 'Janis Santaella', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jonavypiedrahita@gmail.com', 'jonavypiedrahita@gmail.com', 'Jonavy Piedtahita', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-elianapg9294@gmail.com', 'elianapg9294@gmail.com', 'Eliana pena gaitan', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-jorgeramirezdocenciadeportiva@gmail.com', 'jorgeramirezdocenciadeportiva@gmail.com', 'Jorge Ramìrez', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-realty.golden@gmail.com', 'realty.golden@gmail.com', 'Erver Hernández', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-rodriguez22_ashlee@hotmail.com', 'rodriguez22_ashlee@hotmail.com', 'Ashlee estefania rodriguez ramirez', 'Reto 15D', 'active', 37.00, 'USD', NOW()),
  ('RETO15D-fabiobayonarios@gmail.com', 'fabiobayonarios@gmail.com', 'Albert Bayon', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-monimerchan@gmail.com', 'monimerchan@gmail.com', 'Monica Merchan', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-julirolspper@gmail.com', 'julirolspper@gmail.com', 'Carlos Julián', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-jonathan.mrh@outlook.com', 'jonathan.mrh@outlook.com', 'Jonathan Mabiel Rodas Hernandez', 'Reto 15D', 'active', 36.96, 'USD', NOW()),
  ('RETO15D-dpolania92@gmail.com', 'dpolania92@gmail.com', 'Daniel Polania', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-atomatizaciones.ctrl.v@gmail.com', 'atomatizaciones.ctrl.v@gmail.com', 'Jhasson Gonzalez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-mateolambisgomez9@gmail.com', 'mateolambisgomez9@gmail.com', 'Mateo Lambis Gómez', 'Reto 15D', 'active', 36.93, 'USD', NOW()),
  ('RETO15D-julianarias502@gmail.com', 'julianarias502@gmail.com', 'Juliana Arias briceño', 'Reto 15D', 'active', 38.33, 'USD', NOW()),
  ('RETO15D-paul_pb15@hotmail.com', 'paul_pb15@hotmail.com', 'Paul Pintado', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-latindjsoc@gmail.com', 'latindjsoc@gmail.com', 'Paco Villegas', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-joseok86@gmail.com', 'joseok86@gmail.com', 'Jose Oquendo', 'Reto 15D', 'active', 35.00, 'USD', NOW()),
  ('RETO15D-dorothy.gonzalez@figoservices.com', 'dorothy.gonzalez@figoservices.com', 'Dorothy Gonzalez', 'Reto 15D', 'active', 37.02, 'USD', NOW()),
  ('RETO15D-rgonzalez@asesoriasglobales.cl', 'rgonzalez@asesoriasglobales.cl', 'Rodrigo González', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-soyricardocastillo222@gmail.com', 'soyricardocastillo222@gmail.com', 'Ricardo Castillo', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-barradd@gmail.com', 'barradd@gmail.com', 'Deyanira Barragan del Olmo', 'Reto 15D', 'active', 36.58, 'USD', NOW()),
  ('RETO15D-jans1609@gmail.com', 'jans1609@gmail.com', 'Jorge Antonio', 'Reto 15D', 'active', 36.58, 'USD', NOW()),
  ('RETO15D-topetelm@gmail.com', 'topetelm@gmail.com', 'Luis Miguel Topete', 'Reto 15D', 'active', 36.61, 'USD', NOW()),
  ('RETO15D-lcatalina.valencia@gmail.com', 'lcatalina.valencia@gmail.com', 'Catalina Valencia', 'Reto 15D', 'active', 0.37, 'USD', NOW()),
  ('RETO15D-shantajo@hotmail.com', 'shantajo@hotmail.com', 'Santiago lopez', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-mishellecjg@hotmail.com', 'mishellecjg@hotmail.com', 'Mishelle Jimenez G', 'Reto 15D', 'active', 36.61, 'USD', NOW()),
  ('RETO15D-laura.bunge@icloud.com', 'laura.bunge@icloud.com', 'Laura Bunge', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-jhonatan1993aaguilar@gmail.com', 'jhonatan1993aaguilar@gmail.com', 'Jhonatan Aguilar', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-j4tzu3@gmail.com', 'j4tzu3@gmail.com', 'Jatsue rosario', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-manu.valladares90@gmail.com', 'manu.valladares90@gmail.com', 'Manuel Valladares Sandoval', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-maryohaa277@gmail.com', 'maryohaa277@gmail.com', 'Maritza Yohanna Angarita Escobar', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-jorgelinadc@gmail.com', 'jorgelinadc@gmail.com', 'Jorgelina Diaz Cabrera', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-argesestudios@gmail.com', 'argesestudios@gmail.com', 'Víctor Martinez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-rosierod24@gmail.com', 'rosierod24@gmail.com', 'Rosie Rodriguez', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-katyvilleg@gmail.com', 'katyvilleg@gmail.com', 'Katiuska Villegas', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-oriettmarquez@hotmail.com', 'oriettmarquez@hotmail.com', 'Oriett Marquez', 'Reto 15D', 'active', 37.03, 'USD', NOW()),
  ('RETO15D-geinermedinalopez9@gmail.com', 'geinermedinalopez9@gmail.com', 'Geiner Medina', 'Reto 15D', 'active', 36.83, 'USD', NOW()),
  ('RETO15D-jbetts80@gmail.com', 'jbetts80@gmail.com', 'John Betts', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-mariajosezamorano92@gmail.com', 'mariajosezamorano92@gmail.com', 'Maria jose zamorano santos', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-equiposoporteeyj@gmail.com', 'equiposoporteeyj@gmail.com', 'Jhonatan Carrera', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-mohaalm57@gmail.com', 'mohaalm57@gmail.com', 'Mohamed Al mgitni', 'Reto 15D', 'active', 37.35, 'USD', NOW()),
  ('RETO15D-yvanmr777@gmail.com', 'yvanmr777@gmail.com', 'Yvan Martinez Rengifo', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-mario.szp27@gmail.com', 'mario.szp27@gmail.com', 'Mario Suarez Pimentel', 'Reto 15D', 'active', 36.62, 'USD', NOW()),
  ('RETO15D-alexasantysteban@hotmail.com', 'alexasantysteban@hotmail.com', 'Claudia Alexandra Alfonso Galeano', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-hbegazo@grupoissa.org', 'hbegazo@grupoissa.org', 'Hector Begazo', 'Reto 15D', 'active', 36.76, 'USD', NOW()),
  ('RETO15D-noheliaestrad@msn.com', 'noheliaestrad@msn.com', 'Nohelia Patricia Estrada Meza', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-yoli_gh@yahoo.com', 'yoli_gh@yahoo.com', 'Yoli ghisays', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-academiahispanadepnl@gmail.com', 'academiahispanadepnl@gmail.com', 'Sergio Varela', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-johnyposada@hotmail.com', 'johnyposada@hotmail.com', 'Johny posada', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-paolamembrillo@yahoo.com.mx', 'paolamembrillo@yahoo.com.mx', 'Paola Membrillo', 'Reto 15D', 'active', 36.94, 'USD', NOW()),
  ('RETO15D-karlalar@gmail.com', 'karlalar@gmail.com', 'Karla lara', 'Reto 15D', 'active', 36.58, 'USD', NOW()),
  ('RETO15D-nenis.posso@gmail.com', 'nenis.posso@gmail.com', 'Yarenis Posso', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-niurka.jovanovich.luza@gmail.com', 'niurka.jovanovich.luza@gmail.com', 'Niurka Jovanovich', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-garzon.gustavoa@gmail.com', 'garzon.gustavoa@gmail.com', 'Gustavo Garzon', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-kenyadiaz@gmail.com', 'kenyadiaz@gmail.com', 'kenya pamela irina nuñez diaz', 'Reto 15D', 'active', 36.98, 'USD', NOW()),
  ('RETO15D-canilla007@gmail.com', 'canilla007@gmail.com', 'Luis Canilla', 'Reto 15D', 'active', 36.61, 'USD', NOW()),
  ('RETO15D-viwe.org@gmail.com', 'viwe.org@gmail.com', 'CARLOS MANUEL SANDOVAL CANDELAS', 'Reto 15D', 'active', 36.64, 'USD', NOW()),
  ('RETO15D-kerimparra@gmail.com', 'kerimparra@gmail.com', 'Kerim Parra', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-miguelmlemus@gmail.com', 'miguelmlemus@gmail.com', 'Miguel Lemus', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-luisfelipe1213@gmail.com', 'luisfelipe1213@gmail.com', 'Luis Felipe perez Felipe perez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-luzgmay@gmail.com', 'luzgmay@gmail.com', 'Luz Gonzalez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-maria.olavarri27@gmail.com', 'maria.olavarri27@gmail.com', 'María Olavarri', 'Reto 15D', 'active', 36.60, 'USD', NOW()),
  ('RETO15D-tatianaserna1209@gmail.com', 'tatianaserna1209@gmail.com', 'Tatiana Serna', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-danielpinillarojas@gmail.com', 'danielpinillarojas@gmail.com', 'Daniel Pinilla', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-monarchoficial@gmail.com', 'monarchoficial@gmail.com', 'Alex Gómez Ruiz', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-yurgennyrosario@gmail.com', 'yurgennyrosario@gmail.com', 'Yurgenny Rosario', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-roberttolentopro@gmail.com', 'roberttolentopro@gmail.com', 'Robert Tolentino', 'Reto 15D', 'active', 36.87, 'USD', NOW()),
  ('RETO15D-marcela3443.34@gmail.com', 'marcela3443.34@gmail.com', 'MARCELA MORENO', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-chiko228@gmail.com', 'chiko228@gmail.com', 'Jhon faber Ciro', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-lourdes14772@gmail.com', 'lourdes14772@gmail.com', 'Lourdes Garcia', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-bgsaplicaciones@gmail.com', 'bgsaplicaciones@gmail.com', 'Julián Galviz', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-yisethbeltran2006@gmail.com', 'yisethbeltran2006@gmail.com', 'María Beltrán', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-magima89@gmail.com', 'magima89@gmail.com', 'Manuel Gil', 'Reto 15D', 'active', 36.56, 'USD', NOW()),
  ('RETO15D-dratatianaceballos@gmail.com', 'dratatianaceballos@gmail.com', 'Tatiana Ceballos Bautista', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-gadn88@gmail.com', 'gadn88@gmail.com', 'Gustavo duque', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-vcamargod2016@gmail.com', 'vcamargod2016@gmail.com', 'Victor Camargo D', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-oscarjavierpizza@gmail.com', 'oscarjavierpizza@gmail.com', 'Javier Pizza', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-yeraldintriana09@gmail.com', 'yeraldintriana09@gmail.com', 'Yeraldin Triana aponte', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-manuelaepedesign@gmail.com', 'manuelaepedesign@gmail.com', 'Manuela Epe', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-johanita.trusca@gmail.com', 'johanita.trusca@gmail.com', 'Johana caicedo', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-evaromeror@yahoo.com', 'evaromeror@yahoo.com', 'Eva Romero', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-hola@elalgo.co', 'hola@elalgo.co', 'Tatiana Lopez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-vivian.andrea0131@gmail.com', 'vivian.andrea0131@gmail.com', 'Viviana Córdoba', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-tabaresarboleda@gmail.com', 'tabaresarboleda@gmail.com', 'Julian Tabares', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-pabrilda7314@icloud.com', 'pabrilda7314@icloud.com', 'Paula andrea abril Daza', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-yeber32@gmail.com', 'yeber32@gmail.com', 'Davian Vargas', 'Reto 15D', 'active', 0.21, 'USD', NOW()),
  ('RETO15D-verokar2008@gmail.com', 'verokar2008@gmail.com', 'Veronica castro', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-maristizabalh@gmail.com', 'maristizabalh@gmail.com', 'Martin Aristizabal Henao', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-fabianimacias81@gmail.com', 'fabianimacias81@gmail.com', 'Yonier Fabiani Samboni Macias', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-solcitysas@gmail.com', 'solcitysas@gmail.com', 'leonardo fula', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-adecorarbyamb@gmail.com', 'adecorarbyamb@gmail.com', 'Anny Bolivar', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-novahubmk@gmail.com', 'novahubmk@gmail.com', 'Stephany Benavides', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-lopezarellanojuanfrancisco@gmail.com', 'lopezarellanojuanfrancisco@gmail.com', 'Juan Francisco Lopez Arellano', 'Reto 15D', 'active', 36.60, 'USD', NOW()),
  ('RETO15D-cristianspn5417@gmail.com', 'cristianspn5417@gmail.com', 'Cristian steban arcila fonseca', 'Reto 15D', 'active', 38.40, 'USD', NOW()),
  ('RETO15D-candela-007@hotmail.com', 'candela-007@hotmail.com', 'Jeisson candela', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-lauvaler665@gmail.com', 'lauvaler665@gmail.com', 'LAURA RODRIGUEZ', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-infomajestuosamk@gmail.com', 'infomajestuosamk@gmail.com', 'Yuri Zambrano', 'Reto 15D', 'active', 36.72, 'USD', NOW()),
  ('RETO15D-bjdazap@gmail.com', 'bjdazap@gmail.com', 'Billy Daza Pérez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-rriveramaria@gmail.com', 'rriveramaria@gmail.com', 'Maria Rivera', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-alex-2027@hotmail.com', 'alex-2027@hotmail.com', 'Alexander Arroyave', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-carolinerojasb10@gmail.com', 'carolinerojasb10@gmail.com', 'Caroline Rojas', 'Reto 15D', 'active', 36.74, 'USD', NOW()),
  ('RETO15D-salazarsanchezlinafernanda1@gmail.com', 'salazarsanchezlinafernanda1@gmail.com', 'Lina Fernanda Salazar Sánchez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-cesarlozada300@gmail.com', 'cesarlozada300@gmail.com', 'Cesar lozada', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-angie.chavez180497@gmail.com', 'angie.chavez180497@gmail.com', 'Angie Chávez', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-luismiguel.aguirre17@gmail.com', 'luismiguel.aguirre17@gmail.com', 'Luis Miguel Aguirre Gomez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-jareroluis@gmail.com', 'jareroluis@gmail.com', 'Luis Carlos Jarero Martínez', 'Reto 15D', 'active', 36.66, 'USD', NOW()),
  ('RETO15D-jose0717k@gmail.com', 'jose0717k@gmail.com', 'Jose Jaramillo', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-anamas06@hotmail.com', 'anamas06@hotmail.com', 'Ana María Sánchez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-digitalxpresscali@gmail.com', 'digitalxpresscali@gmail.com', 'gabriela florez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-marcosf.amadoc@gmail.com', 'marcosf.amadoc@gmail.com', 'Marcos Amado', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-doracaicedo71@gmail.com', 'doracaicedo71@gmail.com', 'Dora morales', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-esther051996@gmail.com', 'esther051996@gmail.com', 'Esther Guzman', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-erickmonsalvev@gmail.com', 'erickmonsalvev@gmail.com', 'Erick monsalve', 'Reto 15D', 'active', 34.66, 'USD', NOW()),
  ('RETO15D-eloisa.arcos@globalbit.co', 'eloisa.arcos@globalbit.co', 'Eloisa arcos', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-gabamkd@gmail.com', 'gabamkd@gmail.com', 'GIOVANNY ALEXANDER BEDOYA ATEHORTUA', 'Reto 15D', 'active', 37.13, 'USD', NOW()),
  ('RETO15D-allan.pacheco.calderon@gmail.com', 'allan.pacheco.calderon@gmail.com', 'Allan Pacheco Calderón', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-felipeolave@yahoo.com', 'felipeolave@yahoo.com', 'Andrés Olave', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-musico_118@hotmail.com', 'musico_118@hotmail.com', 'Walter Ovalle Gutiérrez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-kevinp96.kp@gmail.com', 'kevinp96.kp@gmail.com', 'Kevin Alan Fabela', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-lupibeltrame2@gmail.com', 'lupibeltrame2@gmail.com', 'Guadalupe Rios', 'Reto 15D', 'active', 37.95, 'USD', NOW()),
  ('RETO15D-caro.savet@gmail.com', 'caro.savet@gmail.com', 'Carolina Romero', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-jonatan.traderfx@gmail.com', 'jonatan.traderfx@gmail.com', 'Jonatan londoño serna', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-mariamlopezmedina@gmail.com', 'mariamlopezmedina@gmail.com', 'Marian lopez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-admonproteccionymas@gmail.com', 'admonproteccionymas@gmail.com', 'Claudia Naranjo', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-edward_27_05@hotmail.com', 'edward_27_05@hotmail.com', 'Edward Orlando Celinz Carreño', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-mysmartlifeco@gmail.com', 'mysmartlifeco@gmail.com', 'Ana Gomez Miranda', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-camarasenfoquearmenia@gmail.com', 'camarasenfoquearmenia@gmail.com', 'JESSYCA ALEJANDRA MORENO GOMEZ', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-yersonsantoskaizen@gmail.com', 'yersonsantoskaizen@gmail.com', 'Yerson santos', 'Reto 15D', 'active', 36.74, 'USD', NOW()),
  ('RETO15D-nadiamulerogordillo@gmail.com', 'nadiamulerogordillo@gmail.com', 'Nadia Mulero Gordillo', 'Reto 15D', 'active', 36.97, 'USD', NOW()),
  ('RETO15D-gerencia@fotoalegria.com.co', 'gerencia@fotoalegria.com.co', 'Jose David Betancur Patiño', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-andersoncruzdigital@gmail.com', 'andersoncruzdigital@gmail.com', 'Anderson Cruz', 'Reto 15D', 'active', 36.58, 'USD', NOW()),
  ('RETO15D-nel_and@hotmail.com', 'nel_and@hotmail.com', 'Nelson Andres Marquez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-jsanta82@hotmail.com', 'jsanta82@hotmail.com', 'Juan Manuel Santa monsalve', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-estebanmejia.sdvsf@gmail.com', 'estebanmejia.sdvsf@gmail.com', 'Juan Esteban', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-camilacr.12@hotmail.com', 'camilacr.12@hotmail.com', 'Maria Camila Calle', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-sandraarbelaeztoro@gmail.com', 'sandraarbelaeztoro@gmail.com', 'Sandra Elizabeth Arbelaez Toro', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-sebasguerrero12@outlook.com', 'sebasguerrero12@outlook.com', 'Daniel Guerrero', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-geovanni.castano@gmail.com', 'geovanni.castano@gmail.com', 'Geovanni Castaño González', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-edwinneduardoreina@gmail.com', 'edwinneduardoreina@gmail.com', 'Edwin Reina', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-valentina990807@hotmail.com', 'valentina990807@hotmail.com', 'Angie alvarez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-damarisnailsexpert@gmail.com', 'damarisnailsexpert@gmail.com', 'Damaris Damaris', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-sofiapinzonramirez16@gmail.com', 'sofiapinzonramirez16@gmail.com', 'Sofia pinzon', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-kserna353@gmail.com', 'kserna353@gmail.com', 'María Katerine Serna Gómez', 'Reto 15D', 'active', 20.90, 'USD', NOW()),
  ('RETO15D-miguegranadav@gmail.com', 'miguegranadav@gmail.com', 'Miguel Angel Vasquez Granada', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-bblandia17@gmail.com', 'bblandia17@gmail.com', 'karla gabriela pascual cruz', 'Reto 15D', 'active', 36.70, 'USD', NOW()),
  ('RETO15D-amastali2@gmail.com', 'amastali2@gmail.com', 'Ana mejia', 'Reto 15D', 'active', 0.37, 'USD', NOW()),
  ('RETO15D-maleja2089@hotmail.com', 'maleja2089@hotmail.com', 'Alejandra alvarez', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-rmmagia@gmail.com', 'rmmagia@gmail.com', 'Ricardo Montoya', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-monicamariagomez78@gmail.com', 'monicamariagomez78@gmail.com', 'Mónica María Gómez Hernández', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-sebastianmcsa77@gmail.com', 'sebastianmcsa77@gmail.com', 'Sebastian Montoya Correa', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-s.caicedo.ocampo@gmail.com', 's.caicedo.ocampo@gmail.com', 'Sebastián Caicedo Ocampo', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-marcela0205@hotmail.com', 'marcela0205@hotmail.com', 'Diana Marcela Duque Garcia', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-jvuc12@hotmail.com', 'jvuc12@hotmail.com', 'jovanny usuga', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-chispaandina@gmail.com', 'chispaandina@gmail.com', 'Dariela Nina Medina', 'Reto 15D', 'active', 36.57, 'USD', NOW()),
  ('RETO15D-conbar74@gmail.com', 'conbar74@gmail.com', 'Libia Constanza Barbosa Galvis', 'Reto 15D', 'active', 36.57, 'USD', NOW())
ON CONFLICT (subscriber_code) DO UPDATE SET
  buyer_name = COALESCE(EXCLUDED.buyer_name, subscriptions.buyer_name),
  updated_at = NOW();

-- PASO 3: Match de teléfonos en transacciones existentes de otros productos
-- Solo actualiza filas donde el email coincide y no hay teléfono todavía
UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'crogutierrez@gmail.com' THEN '15036289631'
    WHEN 'mariamildreyzuluaga@icloud.com' THEN '573106776127'
    WHEN 'linaavilez@hotmail.com' THEN '573135128800'
    WHEN 'juanda125@hotmail.com' THEN '573159265090'
    WHEN 'greycmarseminario@gmail.com' THEN '34656328985'
    WHEN 'alejandra.fernandez.redes@gmail.com' THEN '18296470242'
    WHEN 'jacar170@hotmail.com' THEN '573192054938'
    WHEN 'angeldie8383@gmail.com' THEN '573223716864'
    WHEN 'andresjbd94@gmail.com' THEN '573112036580'
    WHEN 'mcgmaryluz@gmail.com' THEN '573104456107'
    WHEN 'nelsonramirezc2@gmail.com' THEN '573102426113'
    WHEN 'lutraveling.agencia@gmail.com' THEN '573172163491'
    WHEN 'tatianagarcia2616@gmail.com' THEN '573147929390'
    WHEN 'dahiana.cortes.toro@gmail.com' THEN '573225690279'
    WHEN 'milagrosmjvr@hotmail.com' THEN '584246825174'
    WHEN 'msmargaritasarmiento@gmail.com' THEN '17866831492'
    WHEN 'mariamejuto1708@gmail.com' THEN '18506918276'
    WHEN 'mailynok@hotmail.com' THEN '573007516402'
    WHEN 'dcortesph@gmail.com' THEN '573175803263'
    WHEN 'jarojas.hernandez@gmail.com' THEN '573167252700'
    WHEN 'gustaavochaavez@gmail.com' THEN '573114820834'
    WHEN 'juancarlos.ecommerce@gmail.com' THEN '573124910449'
    WHEN 'kattyhealthcoach@gmail.com' THEN '115719917539'
    WHEN 'agrimensurafondeur@hotmail.com' THEN '18498174048'
    WHEN 'lujanperezgeraldine@gmail.com' THEN '573226003051'
    WHEN 'caceres-itpro@outlook.com' THEN '573105167401'
    WHEN 'davidramirezpersonal@gmail.com' THEN '522481331942'
    WHEN 'hectorzamudio183@gmail.com' THEN '573229367175'
    WHEN 'yyaqueline06@gmail.com' THEN '573223685092'
    WHEN 'valeriaruiz_24@hotmail.com' THEN '573209223039'
    WHEN 'ximetello33@gmail.com' THEN '573004487886'
    WHEN 'jaramillovelasquezlaura@gmail.com' THEN '61452078220'
    WHEN 'tessitore1975@hotmail.com' THEN '5930991491861'
    WHEN 'luisaechava@hotmail.com' THEN '573112263230'
    WHEN 'julianmv@hotmail.com' THEN '573147137970'
    WHEN 'johncanoocasal@gmail.com' THEN '573173876699'
    WHEN 'johanescuello27@gmail.com' THEN '573207083307'
    WHEN 'vd944@hotmail.com' THEN '573143272095'
    WHEN 'stalinbravo55@gmail.com' THEN '5930983179938'
    WHEN 'angelicasedi@hotmail.com' THEN '573213718410'
    WHEN 'necha119@hotmail.com' THEN '50661195534'
    WHEN 'pinedaneyrakatheleenbrissette@gmail.com' THEN '393929573676'
    WHEN 'raffocorantes@gmail.com' THEN '51971500350'
    WHEN 'frank.valverde89@gmail.com' THEN '573217788879'
    WHEN 'rony51087@gmail.com' THEN '51944591478'
    WHEN 'gvcapitalinvestment@gmail.com' THEN '12108033569'
    WHEN 'nataliajg1997@gmail.com' THEN '573107814332'
    WHEN 'jmunevcla@live.com' THEN '573134818862'
    WHEN 'leidycordoba@gmail.com' THEN '573117157630'
    WHEN 'catalinaalzate0@gmail.com' THEN '573052320099'
    WHEN 'miguelferu@gmail.com' THEN '573015606277'
    WHEN 'danilozcr@gmail.com' THEN '50684330068'
    WHEN 'marce_corredor@hotmail.com' THEN '573006326905'
    WHEN 'andresbel84@hotmail.com' THEN '573005690280'
    WHEN 'carolina.carmona2@udea.edu.co' THEN '573147121547'
    WHEN 'lilimofl@hotmail.com' THEN '573104039057'
    WHEN 'liz@poleta.co' THEN '573016055080'
    WHEN 'paulitamonsalve@hotmail.com' THEN '573122813447'
    WHEN 'mabel.olivares2707@gmail.com' THEN '18323784074'
    WHEN 'richi120901@gmail.com' THEN '573208623972'
    WHEN 'guifoshamburguesas@gmail.com' THEN '573177767096'
    WHEN 'vicodila.19@gmail.com' THEN '573164502536'
    WHEN 'diegomonroy696@gmail.com' THEN '573223121210'
    WHEN 'steven.moreno155@gmail.com' THEN '573195999136'
    WHEN 'edwin050498@gmail.com' THEN '573183552831'
    WHEN 'johannabanoveliz@gmail.com' THEN '14433197848'
    WHEN 'maujr.94@gmail.com' THEN '573146825651'
    WHEN 'geraldyne2112@gmail.com' THEN '573015049597'
    WHEN 'proyectosgrowth@gmail.com' THEN '573107508849'
    WHEN 'yurymat@hotmail.com' THEN '573045331115'
    WHEN 'inverstru@gmail.com' THEN '573166198645'
    WHEN 'juliovillarreal84@hotmail.com' THEN '573155443972'
    WHEN 'naranjoboteros@gmail.com' THEN '573017911759'
    WHEN 'penamata90@gmail.com' THEN '51946856472'
    WHEN 'mariav0531@hotmail.com' THEN '573115917299'
    WHEN 'muneramichel@outlook.es' THEN '542216044017'
    WHEN 'mauriciodiazrealtor@gmail.com' THEN '573154039866'
    WHEN 'juliperu@gmail.com' THEN '573005720996'
    WHEN 'natalia88saldana@gmail.com' THEN '573146101142'
    WHEN 'alejandra-626@hotmail.com' THEN '573165200435'
    WHEN 'monik25891@hotmail.com' THEN '573145462315'
    WHEN 'edison.patron.sabando@gmail.com' THEN '5930978685097'
    WHEN 'erlymplaceres10@gmail.com' THEN '116093020085'
    WHEN 'mb4marketingagency@gmail.com' THEN '573504649813'
    WHEN 'vargasalvaradotatiana@gmail.com' THEN '573012793741'
    WHEN 'natalia881201@hotmail.com' THEN '573214963877'
    WHEN 'rafael.och8a@gmail.com' THEN '573016157916'
    WHEN 'fliaog65@gmail.com' THEN '573006595089'
    WHEN 'richardace2023@gmail.com' THEN '573138724393'
    WHEN 'luisis012664@gmail.com' THEN '573225692396'
    WHEN 'creamostuestilo.empaquetados@gmail.com' THEN '573042491749'
    WHEN 'suarezstev1@gmail.com' THEN '17542497075'
    WHEN 'heidyjo.loa@gmail.com' THEN '16504764216'
    WHEN 'juan.chicaiza.og@gmail.com' THEN '5930981896969'
    WHEN 'mngomezc09@gmail.com' THEN '573013639008'
    WHEN 'everisieri@gmail.com' THEN '5950981753334'
    WHEN 'erikameneses0128@gmail.com' THEN '573016775795'
    WHEN 'jhonbrandon504@gmail.com' THEN '573133478949'
    WHEN 'cristian.camarin@gmail.com' THEN '573186966867'
    WHEN 'carolina.ramos.em@gmail.com' THEN '573104066023'
    WHEN 'hapedraza1@gmail.com' THEN '19172130364'
    WHEN 'jclo888@hotmail.com' THEN '593987869871'
    WHEN 'aguamarinafashion@gmail.com' THEN '573128088236'
    WHEN 'karenisa14@gmail.com' THEN '112018877569'
    WHEN 'jeiale0429@hotmail.com' THEN '573185218446'
    WHEN 'brayanaguilarsas@gmail.com' THEN '573182120380'
    WHEN 'juanfraglez@gmail.com' THEN '522381026515'
    WHEN 'sofimartinez4994@hotmail.com' THEN '573043888677'
    WHEN 'estefinarvaez-07@hotmail.com' THEN '573145877018'
    WHEN 'angus23sms@gmail.com' THEN '573105554559'
    WHEN 'valeriagonzales071024@gmail.com' THEN '573206142656'
    WHEN 'eileennrodriguez@gmail.com' THEN '117137398223'
    WHEN 'susanaarambulam@gmail.com' THEN '526681030853'
    WHEN 'businessbynatacatano@gmail.com' THEN '573104199649'
    WHEN 'alejoravec@gmail.com' THEN '573004830980'
    WHEN 'vvu920618@gmail.com' THEN '573013473912'
    WHEN 'silvanah2479@gmail.com' THEN '17869617609'
    WHEN 'gonzalezd@ut.edu.co' THEN '573113797062'
    WHEN 'nicolasmillan0532@gmail.com' THEN '117059297111'
    WHEN 'arufino692@gmail.com' THEN '527291100426'
    WHEN 'ogomez0396@gmail.com' THEN '573123174838'
    WHEN 'geraldineandradep1019@gmail.com' THEN '573165358424'
    WHEN 'violetapaos@hotmail.com' THEN '573104946891'
    WHEN 'lauralvargast@gmail.com' THEN '573145969278'
    WHEN 'kellintube@gmail.com' THEN '573014711937'
    WHEN 'valw09010@gmail.com' THEN '573213011254'
    WHEN 'stevmachado07@gmail.com' THEN '573105296214'
    WHEN 'eduardogabriell2004@gmail.com' THEN '5804128541719'
    WHEN 'mabracho@gmail.com' THEN '114077562181'
    WHEN 'santiagolopezm93@gmail.com' THEN '14387220953'
    WHEN 'leydy.plataa@gmail.com' THEN '573174238922'
    WHEN 'lauragomez5413@gmail.com' THEN '573136945040'
    WHEN 'tatiana.palaciosplazas@gmail.com' THEN '19546736404'
    WHEN 'karvalencia@gmail.com' THEN '573218152963'
    WHEN 'andresmoriones1909@gmail.com' THEN '573137196461'
    WHEN 'karenposadazapata@gmail.com' THEN '573042903922'
    WHEN 'julian.vascocalle2@gmail.com' THEN '573013212820'
    WHEN 'claudiahappy74@gmail.com' THEN '447857457007'
    WHEN 'paulaquintero2024@gmail.com' THEN '573004227510'
    WHEN 'maristi1210@gmail.com' THEN '573128214424'
    WHEN 'megabella2020@gmail.com' THEN '573223910857'
    WHEN 'andresrcamargo@gmail.com' THEN '573105510116'
    WHEN 'firstclassbeautybar1@gmail.com' THEN '16176691465'
    WHEN 'netjahlive@hotmail.com' THEN '523322111186'
    WHEN 'danielreyes2904@gmail.com' THEN '573004663651'
    WHEN 'smosquera23@hotmail.com' THEN '573216972716'
    WHEN 'jsernaz1990@gmail.com' THEN '573022394127'
    WHEN 'smoralescarrasquilla@gmail.com' THEN '573123427999'
    WHEN 'montoyajuliana7@gmail.com' THEN '573003813503'
    WHEN 'crisacar81@gmail.com' THEN '573107959002'
    WHEN 'hbce09@gmail.com' THEN '573243679396'
    WHEN 'juancamilomunoz16@gmail.com' THEN '13472956297'
    WHEN 'eco.carlosvalencia7@gmail.com' THEN '573176165090'
    WHEN 'luizingonzalez@hotmail.com' THEN '529991105072'
    WHEN 'chaconclau@gmail.com' THEN '573208471796'
    WHEN 'robingamez11usa@gmail.com' THEN '13218953484'
    WHEN 'ruisusan1@gmail.com' THEN '34690296508'
    WHEN 'juanita.lc46@gmail.com' THEN '573123197598'
    WHEN 'claudiacv733@gmail.com' THEN '12392904862'
    WHEN 'marcela96pereira@hotmail.com' THEN '573177139928'
    WHEN 'stephanny.oberto@gmail.com' THEN '573212248163'
    WHEN 'mjandresorozco@gmail.com' THEN '573174670808'
    WHEN 'juliethlopezmentora@gmail.com' THEN '573187706164'
    WHEN 'simonhurtado37@gmail.com' THEN '573002377716'
    WHEN 'jahircarrillo60@gmail.com' THEN '5930985930116'
    WHEN 'amalfyh_74@hotmail.com' THEN '34631883082'
    WHEN 'santipatino3@gmail.com' THEN '573106694138'
    WHEN 'waffleticali@gmail.com' THEN '573001558657'
    WHEN 'avilaagustin299@gmail.com' THEN '542645877587'
    WHEN 'valeriamazo37@gmail.com' THEN '573244529355'
    WHEN 'andresarias1128@gmail.com' THEN '573226388768'
    WHEN 'nagb77@gmail.com' THEN '12142708537'
    WHEN 'h.patricia.pena@gmail.com' THEN '573013935453'
    WHEN 'yannadelvalle@gmail.com' THEN '573005021007'
    WHEN 'riverosstiven06@gmail.com' THEN '573042001070'
    WHEN 'jennifergiraldo2011@gmail.com' THEN '13525309330'
    WHEN 'ferrolon37@gmail.com' THEN '595986129927'
    WHEN 'angelo_ramirez1204@hotmail.com' THEN '34634130734'
    WHEN 'marketing.13kk@gmail.com' THEN '573188335032'
    WHEN 'didiergalindo20@gmail.com' THEN '573105938975'
    WHEN 'gladyssantizo4@gmail.com' THEN '12817010685'
    WHEN 'jenny.paola.acosta94@gmail.com' THEN '573202393161'
    WHEN 'info@ecologictravel.com.ar' THEN '543772638112'
    WHEN 'carloshidalgo.dvs@icloud.com' THEN '117322772177'
    WHEN 'sandrasalas16@icloud.com' THEN '118458933928'
    WHEN 'ppsalo24@gmail.com' THEN '573144345317'
    WHEN 'leisan85@hotmail.com' THEN '573183397828'
    WHEN 'contacto@dseo.cl' THEN '56987438933'
    WHEN 'rosis2554@gmail.com' THEN '16232022714'
    WHEN 'alexandervelez65@gmail.com' THEN '573197318907'
    WHEN 'stefanyuliethernandez@gmail.com' THEN '573234373165'
    WHEN 'm1atdianabedoya@gmail.com' THEN '573007827689'
    WHEN 'julianramirezv@me.com' THEN '573182526996'
    WHEN 'mharboleda@gmail.com' THEN '573108318163'
    WHEN 'santiagotapiasc+reto@gmail.com' THEN '573218373613'
    WHEN 'jtrujillobetancur+reto@gmail.com' THEN '573105744045'
    WHEN 'creativetiendacol@gmail.com' THEN '573022091014'
    WHEN 'ktgonzalezp9027@gmail.com' THEN '573205090085'
    WHEN 'truebarbersmx@gmail.com' THEN '528126604733'
    WHEN 'estefania.garcia1400@gmail.com' THEN '573215414722'
    ELSE buyer_phone END
WHERE buyer_email IN ('crogutierrez@gmail.com', 'mariamildreyzuluaga@icloud.com', 'linaavilez@hotmail.com', 'juanda125@hotmail.com', 'greycmarseminario@gmail.com', 'alejandra.fernandez.redes@gmail.com', 'jacar170@hotmail.com', 'angeldie8383@gmail.com', 'andresjbd94@gmail.com', 'mcgmaryluz@gmail.com', 'nelsonramirezc2@gmail.com', 'lutraveling.agencia@gmail.com', 'tatianagarcia2616@gmail.com', 'dahiana.cortes.toro@gmail.com', 'milagrosmjvr@hotmail.com', 'msmargaritasarmiento@gmail.com', 'mariamejuto1708@gmail.com', 'mailynok@hotmail.com', 'dcortesph@gmail.com', 'jarojas.hernandez@gmail.com', 'gustaavochaavez@gmail.com', 'juancarlos.ecommerce@gmail.com', 'kattyhealthcoach@gmail.com', 'agrimensurafondeur@hotmail.com', 'lujanperezgeraldine@gmail.com', 'caceres-itpro@outlook.com', 'davidramirezpersonal@gmail.com', 'hectorzamudio183@gmail.com', 'yyaqueline06@gmail.com', 'valeriaruiz_24@hotmail.com', 'ximetello33@gmail.com', 'jaramillovelasquezlaura@gmail.com', 'tessitore1975@hotmail.com', 'luisaechava@hotmail.com', 'julianmv@hotmail.com', 'johncanoocasal@gmail.com', 'johanescuello27@gmail.com', 'vd944@hotmail.com', 'stalinbravo55@gmail.com', 'angelicasedi@hotmail.com', 'necha119@hotmail.com', 'pinedaneyrakatheleenbrissette@gmail.com', 'raffocorantes@gmail.com', 'frank.valverde89@gmail.com', 'rony51087@gmail.com', 'gvcapitalinvestment@gmail.com', 'nataliajg1997@gmail.com', 'jmunevcla@live.com', 'leidycordoba@gmail.com', 'catalinaalzate0@gmail.com', 'miguelferu@gmail.com', 'danilozcr@gmail.com', 'marce_corredor@hotmail.com', 'andresbel84@hotmail.com', 'carolina.carmona2@udea.edu.co', 'lilimofl@hotmail.com', 'liz@poleta.co', 'paulitamonsalve@hotmail.com', 'mabel.olivares2707@gmail.com', 'richi120901@gmail.com', 'guifoshamburguesas@gmail.com', 'vicodila.19@gmail.com', 'diegomonroy696@gmail.com', 'steven.moreno155@gmail.com', 'edwin050498@gmail.com', 'johannabanoveliz@gmail.com', 'maujr.94@gmail.com', 'geraldyne2112@gmail.com', 'proyectosgrowth@gmail.com', 'yurymat@hotmail.com', 'inverstru@gmail.com', 'juliovillarreal84@hotmail.com', 'naranjoboteros@gmail.com', 'penamata90@gmail.com', 'mariav0531@hotmail.com', 'muneramichel@outlook.es', 'mauriciodiazrealtor@gmail.com', 'juliperu@gmail.com', 'natalia88saldana@gmail.com', 'alejandra-626@hotmail.com', 'monik25891@hotmail.com', 'edison.patron.sabando@gmail.com', 'erlymplaceres10@gmail.com', 'mb4marketingagency@gmail.com', 'vargasalvaradotatiana@gmail.com', 'natalia881201@hotmail.com', 'rafael.och8a@gmail.com', 'fliaog65@gmail.com', 'richardace2023@gmail.com', 'luisis012664@gmail.com', 'creamostuestilo.empaquetados@gmail.com', 'suarezstev1@gmail.com', 'heidyjo.loa@gmail.com', 'juan.chicaiza.og@gmail.com', 'mngomezc09@gmail.com', 'everisieri@gmail.com', 'erikameneses0128@gmail.com', 'jhonbrandon504@gmail.com', 'cristian.camarin@gmail.com', 'carolina.ramos.em@gmail.com', 'hapedraza1@gmail.com', 'jclo888@hotmail.com', 'aguamarinafashion@gmail.com', 'karenisa14@gmail.com', 'jeiale0429@hotmail.com', 'brayanaguilarsas@gmail.com', 'juanfraglez@gmail.com', 'sofimartinez4994@hotmail.com', 'estefinarvaez-07@hotmail.com', 'angus23sms@gmail.com', 'valeriagonzales071024@gmail.com', 'eileennrodriguez@gmail.com', 'susanaarambulam@gmail.com', 'businessbynatacatano@gmail.com', 'alejoravec@gmail.com', 'vvu920618@gmail.com', 'silvanah2479@gmail.com', 'gonzalezd@ut.edu.co', 'nicolasmillan0532@gmail.com', 'arufino692@gmail.com', 'ogomez0396@gmail.com', 'geraldineandradep1019@gmail.com', 'violetapaos@hotmail.com', 'lauralvargast@gmail.com', 'kellintube@gmail.com', 'valw09010@gmail.com', 'stevmachado07@gmail.com', 'eduardogabriell2004@gmail.com', 'mabracho@gmail.com', 'santiagolopezm93@gmail.com', 'leydy.plataa@gmail.com', 'lauragomez5413@gmail.com', 'tatiana.palaciosplazas@gmail.com', 'karvalencia@gmail.com', 'andresmoriones1909@gmail.com', 'karenposadazapata@gmail.com', 'julian.vascocalle2@gmail.com', 'claudiahappy74@gmail.com', 'paulaquintero2024@gmail.com', 'maristi1210@gmail.com', 'megabella2020@gmail.com', 'andresrcamargo@gmail.com', 'firstclassbeautybar1@gmail.com', 'netjahlive@hotmail.com', 'danielreyes2904@gmail.com', 'smosquera23@hotmail.com', 'jsernaz1990@gmail.com', 'smoralescarrasquilla@gmail.com', 'montoyajuliana7@gmail.com', 'crisacar81@gmail.com', 'hbce09@gmail.com', 'juancamilomunoz16@gmail.com', 'eco.carlosvalencia7@gmail.com', 'luizingonzalez@hotmail.com', 'chaconclau@gmail.com', 'robingamez11usa@gmail.com', 'ruisusan1@gmail.com', 'juanita.lc46@gmail.com', 'claudiacv733@gmail.com', 'marcela96pereira@hotmail.com', 'stephanny.oberto@gmail.com', 'mjandresorozco@gmail.com', 'juliethlopezmentora@gmail.com', 'simonhurtado37@gmail.com', 'jahircarrillo60@gmail.com', 'amalfyh_74@hotmail.com', 'santipatino3@gmail.com', 'waffleticali@gmail.com', 'avilaagustin299@gmail.com', 'valeriamazo37@gmail.com', 'andresarias1128@gmail.com', 'nagb77@gmail.com', 'h.patricia.pena@gmail.com', 'yannadelvalle@gmail.com', 'riverosstiven06@gmail.com', 'jennifergiraldo2011@gmail.com', 'ferrolon37@gmail.com', 'angelo_ramirez1204@hotmail.com', 'marketing.13kk@gmail.com', 'didiergalindo20@gmail.com', 'gladyssantizo4@gmail.com', 'jenny.paola.acosta94@gmail.com', 'info@ecologictravel.com.ar', 'carloshidalgo.dvs@icloud.com', 'sandrasalas16@icloud.com', 'ppsalo24@gmail.com', 'leisan85@hotmail.com', 'contacto@dseo.cl', 'rosis2554@gmail.com', 'alexandervelez65@gmail.com', 'stefanyuliethernandez@gmail.com', 'm1atdianabedoya@gmail.com', 'julianramirezv@me.com', 'mharboleda@gmail.com', 'santiagotapiasc+reto@gmail.com', 'jtrujillobetancur+reto@gmail.com', 'creativetiendacol@gmail.com', 'ktgonzalezp9027@gmail.com', 'truebarbersmx@gmail.com', 'estefania.garcia1400@gmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'paomazo@gmail.com' THEN '573106364175'
    WHEN 'ladoctoracerebro@gmail.com' THEN '573115065846'
    WHEN 'moniacpa@gmail.com' THEN '573184014448'
    WHEN 'msanchezc97@gmail.com' THEN '573044490502'
    WHEN 'carlosavendano@hotmail.com' THEN '19723591489'
    WHEN 'daniel.outdoor.96@gmail.com' THEN '573008714657'
    WHEN 'juliana@investopi.com' THEN '573105314237'
    WHEN 'marcelarodriguezcaro@yahoo.com' THEN '573228470840'
    WHEN 'loreg97personal@gmail.com' THEN '573182442565'
    WHEN 'dmoyaarevalo78@gmail.com' THEN '16055156175'
    WHEN 'aafragozo@gmail.com' THEN '573116706031'
    WHEN 'ingvhcamargo@hotmail.com' THEN '573113789612'
    WHEN 'anviju0220@gmail.com' THEN '573125918167'
    WHEN 'mauriciogiraldo7877@politecnicomayor.edu.co' THEN '573226699521'
    WHEN 'dannae_martinez@hotmail.com' THEN '573214581798'
    WHEN 'eliana0627gomez@gmail.com' THEN '573204871414'
    WHEN 'jenny.r8@hotmail.com' THEN '573138577664'
    WHEN 'fa503636@gmail.com' THEN '51957678106'
    WHEN 'quicenoandrea87@gmail.com' THEN '573003349669'
    WHEN 'astridbedoya24@gmsil.com' THEN '573183514807'
    WHEN 'samuelfelpa@gmail.com' THEN '573196482486'
    WHEN 'margaritacastillolaviada@gmail.com' THEN '529993638643'
    WHEN 'yormarymontesg@gmail.com' THEN '573188956320'
    WHEN 'jgarnicajimenez@gmail.com' THEN '573113830402'
    WHEN 'yisnesuarez02@gmail.com' THEN '17262448105'
    WHEN 'alejandra.sape@gmail.com' THEN '573128968570'
    WHEN 'genera.propiedades.mx@gmail.com' THEN '525541331877'
    WHEN 'cdagudelo94@gmail.com' THEN '573186234803'
    WHEN 'johanalizgomez@gmail.com' THEN '573202322945'
    WHEN 'eliana.gomezmunoz@gmail.com' THEN '573194849004'
    WHEN 'aureliaquinonez@gmail.com' THEN '573166903386'
    WHEN 'ingclaudiazuluaga@gmail.com' THEN '573104610660'
    WHEN 'eleramosbe@gmail.com' THEN '34656931454'
    WHEN 'davidrom9905@gmail.com' THEN '573058148833'
    WHEN 'cabran112@gmail.com' THEN '573105961049'
    WHEN 'leidyjquintanilla@gmail.com' THEN '573167959444'
    WHEN 'miguelfranco94@hotmail.com' THEN '573004493784'
    WHEN 'bocanegranogueraangie@gmail.com' THEN '573108966634'
    WHEN 'karla.cgommez32@gmail.com' THEN '16693459230'
    WHEN 'vividuran2015@gmail.com' THEN '573209064307'
    WHEN 'katherine.cortess1@gmail.com' THEN '573165329994'
    WHEN 'danielcorrealopez11@gmail.com' THEN '573024141134'
    WHEN 'castillomaria911005@gmail.com' THEN '573053200511'
    WHEN 'dianaraquelpenar@gmail.com' THEN '573016785136'
    WHEN 'davidpe30@outlook.com' THEN '573204460682'
    WHEN 'nini-jhova@hotmail.com' THEN '573144200564'
    WHEN 'cruzheidy58@gmail.com' THEN '573052929053'
    WHEN 'cablanpa@gmail.com' THEN '573152116116'
    WHEN 'jgvroach19@outlook.com' THEN '50683069420'
    WHEN 'yessikap9301@gmail.com' THEN '573024025941'
    WHEN 'judaniel16@gmail.com' THEN '573227028201'
    WHEN 'zayratriana@hotmail.com' THEN '573162570827'
    WHEN 'felipe25733@gmail.com' THEN '573130539670'
    WHEN 'cmelannyb@gmail.com' THEN '573126566680'
    WHEN 'samluis292@gmail.com' THEN '573182548081'
    WHEN 'marito8601@hotmail.com' THEN '573108616357'
    WHEN 'ingsheilabelandria@gmail.com' THEN '573208181707'
    WHEN 'valenmuch70@gmail.com' THEN '573176412813'
    WHEN 'danielaortizb7@gmail.com' THEN '573004885689'
    WHEN 'claudiagiselle84@gmail.com' THEN '51960531314'
    WHEN 'juanabenavides0815@gmail.com' THEN '573104874558'
    WHEN 'gustavovasquez.1624@gmail.com' THEN '573167446552'
    WHEN 'isaromero2021@gmail.com' THEN '573008035827'
    WHEN 'bymayelaroman@gmail.com' THEN '17868706272'
    WHEN 'jomiva@hotmail.com' THEN '573128389663'
    WHEN 'jucaloba3@gmail.com' THEN '573004862158'
    WHEN 'milenag227@gmail.com' THEN '573159272911'
    WHEN 'vl2683431@gmail.com' THEN '573145502087'
    WHEN 'yurani.v.garcia@gmail.com' THEN '573213889581'
    WHEN 'jose-ts01@outlook.com' THEN '573238110338'
    WHEN 'davidbarpf@hotmail.com' THEN '525516512769'
    WHEN 'erikanavas24@gmail.com' THEN '13059249981'
    WHEN 'cursosgpo@gmail.com' THEN '573177772392'
    WHEN 'mhperez1801@gmail.com' THEN '573015481345'
    WHEN 'juli.riveracr@gmail.com' THEN '573164429059'
    WHEN 'francofuentes2@gmail.com' THEN '573102176760'
    WHEN 'hola@efectogrowth.com' THEN '573012522914'
    WHEN 'karenrojasm19@gmail.com' THEN '51928793874'
    WHEN 'gomezserna.paola@gmail.com' THEN '573176457856'
    WHEN 'felipecurvelo@hotmail.com' THEN '573103243375'
    WHEN 'rosalia_jaol@hotmail.com' THEN '14695603691'
    WHEN 'ginatbaldion@gmail.com' THEN '573107894475'
    WHEN 'jencano18@gmail.com' THEN '573153865634'
    WHEN 'carloscartagena2405@gmail.com' THEN '573007016022'
    WHEN 'marce.1524@hotmail.com' THEN '573027133990'
    WHEN 'cmurillomurillo92@gmail.com' THEN '573006056506'
    WHEN 'osanchez9991@gmail.com' THEN '50495192673'
    WHEN 'juanfmarulanda00@outlook.com' THEN '573123490968'
    WHEN 'astronomo87@gmail.com' THEN '573136029013'
    WHEN 'adeanahbl@gmail.com' THEN '573178883544'
    WHEN 'lorygil26@gmail.com' THEN '573008490828'
    WHEN 'wendytamayo@hotmail.com' THEN '573134730717'
    WHEN 'adsjoserojas@gmail.com' THEN '5930987763094'
    WHEN 'ardila.ing@gmail.com' THEN '573166073360'
    WHEN 'martinabenal@hotmail.com' THEN '5930999024158'
    WHEN 'julian09.jl@gmail.com' THEN '573188089121'
    WHEN 'michellemoav@hotmail.com' THEN '525634512418'
    WHEN 'juancamilomosari@gmail.com' THEN '573163204123'
    WHEN 'gabrimora21@gmail.com' THEN '573132971150'
    WHEN 'melyocampo06@hotmail.com' THEN '19542031321'
    WHEN 'somosmarketingam@gmail.com' THEN '573186705201'
    WHEN 'colorclick2014@gmail.com' THEN '573154991099'
    WHEN 'katherin4280@hotmail.com' THEN '573104360167'
    WHEN 'vaneporti2@gmail.com' THEN '573152525960'
    WHEN 'decokidscuadritosconamor@gmail.com' THEN '573147316061'
    WHEN 'sailyscardenasm@hotmail.com' THEN '573218747274'
    WHEN 'solutececommerce@gmail.com' THEN '573132159136'
    WHEN 'solmarianagranadosvargas@gmail.com' THEN '573202691366'
    WHEN 'morenocorreadk@gmail.com' THEN '573162523174'
    WHEN 'jpbustamante20@outlook.com' THEN '573152116931'
    WHEN 'iveenaranjo@gmail.com' THEN '5930958747727'
    WHEN 'alexandra_14533669@hotmail.com' THEN '573123142411'
    WHEN 'marcelamacias2016@gmail.com' THEN '573004340895'
    WHEN 'cliosocialescan@gmail.com' THEN '573208028294'
    WHEN 'jhanpineda24@gmail.com' THEN '573103515780'
    WHEN 'hernandezyasmely@gmail.com' THEN '117867095813'
    WHEN 'daohe16@gmail.com' THEN '117869393335'
    WHEN 'foixcar@gmail.com' THEN '543815438868'
    WHEN 'melisagiraldo.ai@gmail.com' THEN '573215674512'
    WHEN 'mennarcompras@hotmail.com' THEN '573116315342'
    WHEN 'info@jhonnvesga.com' THEN '573203435164'
    WHEN 'virgicordeiro@gmail.com' THEN '598092557501'
    WHEN 'maricleir2@gmail.com' THEN '573045709355'
    WHEN 'jeniffervente.publicidad@gmail.com' THEN '573182714899'
    WHEN 'tiendalunabymarisol@gmail.com' THEN '522297689627'
    WHEN 'alejandra.parraq04@gmail.com' THEN '573027199492'
    WHEN 'dasha.planticas@gmail.com' THEN '573182658995'
    WHEN 'marcelsalazar80@hotmail.com' THEN '573176491303'
    WHEN 'misabel_rivera@hotmail.com' THEN '573208533957'
    WHEN 'leidy.4491@gmail.com' THEN '573002329908'
    WHEN 'loamylobo656@gmail.com' THEN '17732691775'
    WHEN 'intluiscorrea@gmail.com' THEN '573016897361'
    WHEN 'clarainesaristizabal0421@gmail.com' THEN '573015514252'
    WHEN 'diegogz.2709@gmail.com' THEN '573102986437'
    WHEN 'maria.francho@hotmail.com' THEN '573113049406'
    WHEN 'racast163043@gmail.com' THEN '19197440877'
    WHEN 'fabio157maje@gmail.com' THEN '573105802161'
    WHEN 'camilavelasquez721@gmail.com' THEN '573005411725'
    WHEN 'juantorres2589@gmail.com' THEN '50761548819'
    WHEN 'alex.28.92@icloud.com' THEN '14073424490'
    WHEN 'camiloaguirre1806@gmail.com' THEN '573133406497'
    WHEN 'floryreyes2090@gmail.com' THEN '13476545576'
    WHEN 'miguelfotos162@gmail.com' THEN '525536700983'
    WHEN 'leidymarcelamedinasanchez@hotmail.com' THEN '573205953863'
    WHEN 'nicolarango20@hotmail.com' THEN '573185904871'
    WHEN 'bigpotentialmarketing@gmail.com' THEN '573014308618'
    WHEN 'katerineareiza75@gmail.com' THEN '573215147509'
    WHEN 'storedn20@gmail.com' THEN '573138303965'
    WHEN 'sjuan7709@gmail.com' THEN '113853844502'
    WHEN 'lmbv15011979@gmail.com' THEN '573216037375'
    WHEN 'microcapilart@gmail.com' THEN '573002177899'
    WHEN 'salgueroca@hotmail.com' THEN '573185562483'
    WHEN 'dk96@outlook.com' THEN '593984348441'
    WHEN 'zuluagaanduquiamayradaniela@gmail.com' THEN '573205866668'
    WHEN 'anacsf96@gmail.com' THEN '573184924524'
    WHEN 'wrcomercioelectronico@gmail.com' THEN '573184356344'
    WHEN 'camigar808@gmail.com' THEN '573154510292'
    WHEN 'jholman314@gmail.com' THEN '573161001189'
    WHEN 'argeliachasan@gmail.com' THEN '522224305494'
    WHEN 'menichinismart@gmail.com' THEN '18017921542'
    WHEN 'liiscoar@hotmail.com' THEN '573112350885'
    WHEN 'vivicolorsmake.up@gmail.com' THEN '117863390924'
    WHEN 'karendell96@hotmail.com' THEN '573203273626'
    WHEN 'derlyholpaez89@gmail.com' THEN '573213896613'
    WHEN 'davasu88@gmail.com' THEN '573113711347'
    WHEN 'ricardoggoenaga@gmail.com' THEN '524431374486'
    WHEN 'etowersit@gmail.com' THEN '525516960814'
    WHEN 'patymatikas@gmail.com' THEN '573186448481'
    WHEN 'pierpulido@gmail.com' THEN '573003295241'
    WHEN 'delarosacreativos@gmail.com' THEN '573013854186'
    WHEN 'loyolaovallema@gmail.com' THEN '17862800147'
    WHEN 'paomylepr@gmail.com' THEN '573046615123'
    WHEN 'santo-357@hotmail.com' THEN '573232263758'
    WHEN 'cflorezpinilla@gmail.com' THEN '573123443726'
    WHEN 'sergiogg200404@gmail.com' THEN '573212545596'
    WHEN 'esperanza733@hotmail.com' THEN '573114420337'
    WHEN 'catarias.81@gmail.com' THEN '573104539226'
    WHEN 'jeco23@hotmail.com' THEN '573135941800'
    WHEN 'yulicasfra@gmail.com' THEN '573046787143'
    WHEN 'priscyg@gmail.com' THEN '523111591726'
    WHEN 'camilach.25@outlook.com' THEN '573123691286'
    WHEN 'cristian09giraldo@gmail.com' THEN '573044437837'
    WHEN 'mariafonnegra11@gmail.com' THEN '573226475836'
    WHEN 'tacasaurio@gmail.com' THEN '573224967727'
    WHEN 'elmundodelaplatachile@gmail.com' THEN '56966486330'
    WHEN 'mafe_andrade@hotmail.com' THEN '593985828434'
    WHEN 'melgarejo07@hotmail.com' THEN '573006321297'
    WHEN 'ivalencia29@hotmail.com' THEN '50762658780'
    WHEN 'andreabriceno_15@hotmail.com' THEN '573107645047'
    WHEN 'lilivel87@hotmail.com' THEN '573128697335'
    WHEN 'lissethmarcela1@gmail.com' THEN '573004326851'
    WHEN 'mapug.educacion@gmail.com' THEN '573213446990'
    WHEN 'emreyesq@gmail.com' THEN '573013722960'
    WHEN 'meneses.co@softmix.click' THEN '573197292019'
    WHEN 'dracarlacardenas@gmail.com' THEN '573117154540'
    WHEN 'iskralanducci96@gmail.com' THEN '593987652024'
    WHEN 'andres.sosa01@hotmail.com' THEN '573177427483'
    WHEN 'cgstudiove@gmail.com' THEN '13233026458'
    WHEN 'catherine.baronc@gmail.com' THEN '573107722910'
    WHEN 'yralisbetancourt70@gmail.com' THEN '573188242555'
    ELSE buyer_phone END
WHERE buyer_email IN ('paomazo@gmail.com', 'ladoctoracerebro@gmail.com', 'moniacpa@gmail.com', 'msanchezc97@gmail.com', 'carlosavendano@hotmail.com', 'daniel.outdoor.96@gmail.com', 'juliana@investopi.com', 'marcelarodriguezcaro@yahoo.com', 'loreg97personal@gmail.com', 'dmoyaarevalo78@gmail.com', 'aafragozo@gmail.com', 'ingvhcamargo@hotmail.com', 'anviju0220@gmail.com', 'mauriciogiraldo7877@politecnicomayor.edu.co', 'dannae_martinez@hotmail.com', 'eliana0627gomez@gmail.com', 'jenny.r8@hotmail.com', 'fa503636@gmail.com', 'quicenoandrea87@gmail.com', 'astridbedoya24@gmsil.com', 'samuelfelpa@gmail.com', 'margaritacastillolaviada@gmail.com', 'yormarymontesg@gmail.com', 'jgarnicajimenez@gmail.com', 'yisnesuarez02@gmail.com', 'alejandra.sape@gmail.com', 'genera.propiedades.mx@gmail.com', 'cdagudelo94@gmail.com', 'johanalizgomez@gmail.com', 'eliana.gomezmunoz@gmail.com', 'aureliaquinonez@gmail.com', 'ingclaudiazuluaga@gmail.com', 'eleramosbe@gmail.com', 'davidrom9905@gmail.com', 'cabran112@gmail.com', 'leidyjquintanilla@gmail.com', 'miguelfranco94@hotmail.com', 'bocanegranogueraangie@gmail.com', 'karla.cgommez32@gmail.com', 'vividuran2015@gmail.com', 'katherine.cortess1@gmail.com', 'danielcorrealopez11@gmail.com', 'castillomaria911005@gmail.com', 'dianaraquelpenar@gmail.com', 'davidpe30@outlook.com', 'nini-jhova@hotmail.com', 'cruzheidy58@gmail.com', 'cablanpa@gmail.com', 'jgvroach19@outlook.com', 'yessikap9301@gmail.com', 'judaniel16@gmail.com', 'zayratriana@hotmail.com', 'felipe25733@gmail.com', 'cmelannyb@gmail.com', 'samluis292@gmail.com', 'marito8601@hotmail.com', 'ingsheilabelandria@gmail.com', 'valenmuch70@gmail.com', 'danielaortizb7@gmail.com', 'claudiagiselle84@gmail.com', 'juanabenavides0815@gmail.com', 'gustavovasquez.1624@gmail.com', 'isaromero2021@gmail.com', 'bymayelaroman@gmail.com', 'jomiva@hotmail.com', 'jucaloba3@gmail.com', 'milenag227@gmail.com', 'vl2683431@gmail.com', 'yurani.v.garcia@gmail.com', 'jose-ts01@outlook.com', 'davidbarpf@hotmail.com', 'erikanavas24@gmail.com', 'cursosgpo@gmail.com', 'mhperez1801@gmail.com', 'juli.riveracr@gmail.com', 'francofuentes2@gmail.com', 'hola@efectogrowth.com', 'karenrojasm19@gmail.com', 'gomezserna.paola@gmail.com', 'felipecurvelo@hotmail.com', 'rosalia_jaol@hotmail.com', 'ginatbaldion@gmail.com', 'jencano18@gmail.com', 'carloscartagena2405@gmail.com', 'marce.1524@hotmail.com', 'cmurillomurillo92@gmail.com', 'osanchez9991@gmail.com', 'juanfmarulanda00@outlook.com', 'astronomo87@gmail.com', 'adeanahbl@gmail.com', 'lorygil26@gmail.com', 'wendytamayo@hotmail.com', 'adsjoserojas@gmail.com', 'ardila.ing@gmail.com', 'martinabenal@hotmail.com', 'julian09.jl@gmail.com', 'michellemoav@hotmail.com', 'juancamilomosari@gmail.com', 'gabrimora21@gmail.com', 'melyocampo06@hotmail.com', 'somosmarketingam@gmail.com', 'colorclick2014@gmail.com', 'katherin4280@hotmail.com', 'vaneporti2@gmail.com', 'decokidscuadritosconamor@gmail.com', 'sailyscardenasm@hotmail.com', 'solutececommerce@gmail.com', 'solmarianagranadosvargas@gmail.com', 'morenocorreadk@gmail.com', 'jpbustamante20@outlook.com', 'iveenaranjo@gmail.com', 'alexandra_14533669@hotmail.com', 'marcelamacias2016@gmail.com', 'cliosocialescan@gmail.com', 'jhanpineda24@gmail.com', 'hernandezyasmely@gmail.com', 'daohe16@gmail.com', 'foixcar@gmail.com', 'melisagiraldo.ai@gmail.com', 'mennarcompras@hotmail.com', 'info@jhonnvesga.com', 'virgicordeiro@gmail.com', 'maricleir2@gmail.com', 'jeniffervente.publicidad@gmail.com', 'tiendalunabymarisol@gmail.com', 'alejandra.parraq04@gmail.com', 'dasha.planticas@gmail.com', 'marcelsalazar80@hotmail.com', 'misabel_rivera@hotmail.com', 'leidy.4491@gmail.com', 'loamylobo656@gmail.com', 'intluiscorrea@gmail.com', 'clarainesaristizabal0421@gmail.com', 'diegogz.2709@gmail.com', 'maria.francho@hotmail.com', 'racast163043@gmail.com', 'fabio157maje@gmail.com', 'camilavelasquez721@gmail.com', 'juantorres2589@gmail.com', 'alex.28.92@icloud.com', 'camiloaguirre1806@gmail.com', 'floryreyes2090@gmail.com', 'miguelfotos162@gmail.com', 'leidymarcelamedinasanchez@hotmail.com', 'nicolarango20@hotmail.com', 'bigpotentialmarketing@gmail.com', 'katerineareiza75@gmail.com', 'storedn20@gmail.com', 'sjuan7709@gmail.com', 'lmbv15011979@gmail.com', 'microcapilart@gmail.com', 'salgueroca@hotmail.com', 'dk96@outlook.com', 'zuluagaanduquiamayradaniela@gmail.com', 'anacsf96@gmail.com', 'wrcomercioelectronico@gmail.com', 'camigar808@gmail.com', 'jholman314@gmail.com', 'argeliachasan@gmail.com', 'menichinismart@gmail.com', 'liiscoar@hotmail.com', 'vivicolorsmake.up@gmail.com', 'karendell96@hotmail.com', 'derlyholpaez89@gmail.com', 'davasu88@gmail.com', 'ricardoggoenaga@gmail.com', 'etowersit@gmail.com', 'patymatikas@gmail.com', 'pierpulido@gmail.com', 'delarosacreativos@gmail.com', 'loyolaovallema@gmail.com', 'paomylepr@gmail.com', 'santo-357@hotmail.com', 'cflorezpinilla@gmail.com', 'sergiogg200404@gmail.com', 'esperanza733@hotmail.com', 'catarias.81@gmail.com', 'jeco23@hotmail.com', 'yulicasfra@gmail.com', 'priscyg@gmail.com', 'camilach.25@outlook.com', 'cristian09giraldo@gmail.com', 'mariafonnegra11@gmail.com', 'tacasaurio@gmail.com', 'elmundodelaplatachile@gmail.com', 'mafe_andrade@hotmail.com', 'melgarejo07@hotmail.com', 'ivalencia29@hotmail.com', 'andreabriceno_15@hotmail.com', 'lilivel87@hotmail.com', 'lissethmarcela1@gmail.com', 'mapug.educacion@gmail.com', 'emreyesq@gmail.com', 'meneses.co@softmix.click', 'dracarlacardenas@gmail.com', 'iskralanducci96@gmail.com', 'andres.sosa01@hotmail.com', 'cgstudiove@gmail.com', 'catherine.baronc@gmail.com', 'yralisbetancourt70@gmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'akire1784@hotmail.com' THEN '573182224055'
    WHEN 'angieepa19@gmail.com' THEN '584149013371'
    WHEN 'angelaordonez1234@gmail.com' THEN '573016223159'
    WHEN 'lindawongvillacis@yahoo.es' THEN '5930993007799'
    WHEN 'karenfuxion24@gmail.com' THEN '573504946866'
    WHEN 'maye.t.gomez@hotmail.com' THEN '573168778369'
    WHEN 'marypatry54@hotmail.com' THEN '573008116511'
    WHEN 'gonzalez.jek@gmail.com' THEN '573044933927'
    WHEN 'robertojose032019@gmail.com' THEN '573002691723'
    WHEN 'carlosfabianrojas10@hotmail.com' THEN '573132827582'
    WHEN 'limalemu@gmail.com' THEN '573226799338'
    WHEN 'fragancee8@gmail.com' THEN '573104065887'
    WHEN 'yuriprojas@yahoo.es' THEN '573202834075'
    WHEN 'mxzonestore@gmail.com' THEN '573135060224'
    WHEN 'andresfella@hotmail.com' THEN '573184001306'
    WHEN 'carolina.blanco@velawhite.com' THEN '51999962140'
    WHEN 'ricardopinilla9@hotmail.com' THEN '573113931989'
    WHEN 'jjairo171@gmail.com' THEN '573007947693'
    WHEN 'studiolombaitcorp@gmail.com' THEN '13054145555'
    WHEN 'wilopupilo@gmail.com' THEN '573143220373'
    WHEN 'carolinarueda1608@gmail.com' THEN '573208402192'
    WHEN 'lgjohana10@gmail.com' THEN '573147501873'
    WHEN 'guzceballos1@gmail.com' THEN '573104570757'
    WHEN 'patosandy2711@gmail.com' THEN '17869702343'
    WHEN 'mardiazin@gmail.com' THEN '573137114295'
    WHEN 'soniavera38@gmail.com' THEN '18562364412'
    WHEN 'laucanina@outlook.com' THEN '573112411509'
    WHEN 'shepard.ohonsi.sob@gmail.com' THEN '51974132764'
    WHEN 'zullyalejandra@gmail.com' THEN '573012753968'
    WHEN 'addys2353@gmail.com' THEN '593992503573'
    WHEN 'danielaospinarmodel@gmail.com' THEN '573147108538'
    WHEN 'leidymillan23@gmail.com' THEN '13054406852'
    WHEN 'daniroman27@hotmail.com' THEN '573507844600'
    WHEN 'nana_saldarriaga@hotmail.com' THEN '18134361044'
    WHEN 'gerencia.idh@gmail.com' THEN '573005064359'
    WHEN 'nunezyasira88@gmail.com' THEN '16318301447'
    WHEN 'gutierrezclady@gmail.com' THEN '50765078176'
    WHEN 'amorenoc100@yahoo.es' THEN '34604261898'
    WHEN 'cursos@markiany.com' THEN '112148081885'
    WHEN 'mpiedrahitagutierrez@gmail.com' THEN '573105463555'
    WHEN 'jjcolorador@gmail.com' THEN '573246859545'
    WHEN 'pepitoperez007@protonmail.com' THEN '573123578965'
    WHEN 'pangeabeer@gmail.com' THEN '573152933968'
    WHEN 'linalotteart@gmail.com' THEN '5930989728510'
    WHEN 'bajosusalasarte@gmail.com' THEN '573146786217'
    WHEN 'familiaalexaspa@gmail.com' THEN '573146020071'
    WHEN 'dramosyarleque@gmail.com' THEN '51995869109'
    WHEN 'pipe_duque@hotmail.com' THEN '573187099189'
    WHEN 'deyarubio@gmail.com' THEN '524422502571'
    WHEN 'blendysramos@gmail.com' THEN '573008860840'
    WHEN 'prisvivarv@gmail.com' THEN '5930987666552'
    WHEN 'isahh25@gmail.com' THEN '573183897932'
    WHEN 'remolinaalbert@gmail.com' THEN '573128706400'
    WHEN 'mazzarelli2017@gmail.com' THEN '56973463015'
    WHEN 'giovanni.alf.mar@gmail.com' THEN '51926907148'
    WHEN 'gabo71136244@gmail.com' THEN '5930995686032'
    WHEN 'bibianita12@hotmail.com' THEN '573235801627'
    WHEN 'harrymdigital@outlook.com' THEN '573164090984'
    WHEN 'marcelastefany9@gmail.com' THEN '573192401803'
    WHEN 'holy.interiorfemenino@gmail.com' THEN '573206725147'
    WHEN 'xiomyhenao18@hotmail.es' THEN '573104043527'
    WHEN 'lilipod12@hotmail.com' THEN '573223318752'
    WHEN 'lpablo59@gmail.com' THEN '5930995331834'
    WHEN 'pilotoguerrero281@gmail.com' THEN '573124910138'
    WHEN 'infolizhernandez@gmail.com' THEN '573058606706'
    WHEN 'christianleoval@hotmail.com' THEN '573207932056'
    WHEN 'carolina.tabarez.ct@gmail.com' THEN '573206890430'
    WHEN 'mad6812@gmail.com' THEN '573025315565'
    WHEN 'infomeliospinacocinacocina@gmail.com' THEN '573216394990'
    WHEN 'csmafra@gmail.com' THEN '573015463548'
    WHEN 'qdenisse@gmail.com' THEN '5930984934039'
    WHEN 'velagiraldo@gmail.com' THEN '573017713126'
    WHEN 'pattylunadr@gmail.com' THEN '526441551474'
    WHEN 'katelonga@hotmail.com' THEN '573219041876'
    WHEN 'docabreras.pe@gmail.com' THEN '51946951327'
    WHEN 'jess0235marketing@gmail.com' THEN '17864062199'
    WHEN 'andrewzerva0903@gmail.com' THEN '584142661285'
    WHEN 'mariana.valenciac@autonoma.edu.co' THEN '573003208323'
    WHEN 'johsef4dmrs@gmail.com' THEN '529997470509'
    WHEN 'zapataduberandres@gmail.com' THEN '573217664727'
    WHEN 'sebastianlondonoj@gmail.com' THEN '573002018657'
    WHEN 'andresgiraldo325@gmail.com' THEN '573045827695'
    WHEN 'hassel.ortegapelaez@gmail.com' THEN '525618356363'
    WHEN 'jamerq.91@gmail.com' THEN '573192267698'
    WHEN 'brayangonzalesmejia321@gmail.com' THEN '573143184278'
    WHEN 'perla_87743@hotmail.com' THEN '19154714640'
    WHEN 'germancorreamarin@gmail.com' THEN '112013204883'
    WHEN 'gcamachoh95@gmail.com' THEN '525540578082'
    WHEN 'yureesly1981@gmail.com' THEN '5930984269194'
    WHEN 'cardonacami29@gmail.com' THEN '573145258798'
    WHEN 'pedropaucar37@gmail.com' THEN '14435224294'
    WHEN 'lissoexpresvip@gmail.com' THEN '573158222233'
    WHEN 'emprendeconalexa@gmail.com' THEN '573173759486'
    WHEN 'anndres903@gmail.com' THEN '573208560816'
    WHEN 'laagmvz@gmail.com' THEN '573185902414'
    WHEN 'dianapatriciaca@gmail.com' THEN '5930969379408'
    WHEN 'angel.aycardi@outlook.com' THEN '573127671232'
    WHEN 'jamesvdigital@gmail.com' THEN '573023678870'
    WHEN 'juanjo.0121@outlook.com' THEN '573204366740'
    WHEN 'dianatristancholache@gmail.com' THEN '573016740197'
    WHEN 'nomadasdecorazontravel@gmail.com' THEN '573164178882'
    WHEN 'sallymay08@hotmail.com' THEN '573014262122'
    WHEN 'diani.sierra@yahoo.com' THEN '573017355195'
    WHEN 'erikaplatas01@gmail.com' THEN '573123539334'
    WHEN 'fafr81294@gmail.com' THEN '573028501418'
    WHEN 'gabiuss25@hotmail.com' THEN '17187856099'
    WHEN 'fabiolaandueza@gmail.com' THEN '573175690966'
    WHEN 'adrianapramirezo@hotmail.com' THEN '573133731993'
    WHEN 'beatrizhernandezc1@gmail.com' THEN '573137679165'
    WHEN 'armoventas.atencion@gmail.com' THEN '523316708073'
    WHEN 'sayu.cantillo@gmail.com' THEN '573015644493'
    WHEN 'raquelramirez15@gmail.com' THEN '573223115070'
    WHEN '2dfavilla@gmail.com' THEN '17185106076'
    WHEN 'benja.flores.bta@gmail.com' THEN '527711297145'
    WHEN 'lilianahl@icloud.com' THEN '573113411221'
    WHEN 'jasipachano@gmail.com' THEN '573127482163'
    WHEN 'fager777@gmail.com' THEN '573192982963'
    WHEN 'maribel.bellisima501@gmail.com' THEN '13237077015'
    WHEN 'yanurca_90@hotmail.com' THEN '573160404041'
    WHEN 'paolarodriguezrealtor@gmail.com' THEN '17867155492'
    WHEN 'ariess1986@gmail.com' THEN '573178913034'
    WHEN 'aleja_9910_@hotmail.com' THEN '573202274562'
    WHEN 'yuland8825@hotmail.com' THEN '573148101878'
    WHEN 'danielaramirez.9394@gmail.com' THEN '573008651731'
    WHEN 'patriciadoncel@gmail.com' THEN '13236102307'
    WHEN 'ceo.harleycardozo@gmail.com' THEN '573112458443'
    WHEN 'deiviaguillon15@gmail.com' THEN '573132158297'
    WHEN 'lasgordas07@gmail.com' THEN '573214614480'
    WHEN 'biancamga1981@gmail.com' THEN '17864368033'
    WHEN 'emmanuellaraosorio@gmail.com' THEN '525617344912'
    WHEN 'dayajuanes@gmail.com' THEN '573194240124'
    WHEN 'lozanitoml@gmail.com' THEN '5930983180069'
    WHEN 'cordobajehiver@gmail.com' THEN '573229201748'
    WHEN 'francisco16.murilloz@gmail.com' THEN '573004206261'
    WHEN 'david_cardona16@hotmail.com' THEN '573046401161'
    WHEN 'tomasina2718@yahoo.com' THEN '116097277671'
    WHEN 'cryptonano18@gmail.com' THEN '51949666157'
    WHEN 'luisamanriquebarrera1995@gmail.com' THEN '573216679242'
    WHEN 'jorgedavidqw@gmail.com' THEN '573207365613'
    WHEN 'juliajimenezarr@gmail.com' THEN '17868163650'
    WHEN 'kam.cuervo@gmail.com' THEN '573059259282'
    WHEN 'yaime71@yahoo.com' THEN '17163499991'
    WHEN 'tomasm235@gmail.com' THEN '573186377546'
    WHEN 'anamjaramillov@gmail.com' THEN '573104353609'
    WHEN 'tatisuarez593@gmail.com' THEN '573146172815'
    WHEN 'kevin.valenzuela000@gmail.com' THEN '573229187468'
    WHEN 'gabrielriveravillamizar@gmail.com' THEN '573112777802'
    WHEN 'carlos.bismarck36@gmail.com' THEN '523111055123'
    WHEN 'cyn.pr16@hotmail.com' THEN '522227361946'
    WHEN 'dianita1809@hotmail.com' THEN '573045586003'
    WHEN 'paolatca@yahoo.com' THEN '573006747445'
    WHEN 'andresredmusic@gmail.com' THEN '573044313216'
    WHEN 'yefersonandreshernandez1@gmail.com' THEN '573002079041'
    WHEN 'zulma_kmc92@hotmail.com' THEN '523221078231'
    WHEN 'hotmartcmc@gmail.com' THEN '573144391836'
    WHEN 'cagd2000@gmail.com' THEN '573007845773'
    WHEN 'alexandramazuerarealtor@gmail.com' THEN '117866206262'
    WHEN 'vanidadybelleza@hotmail.com' THEN '573147508381'
    WHEN 'fernandorangel261121@gmail.com' THEN '573013240412'
    WHEN 'piguasbebes@gmail.com' THEN '573046156929'
    WHEN 'abigailgarcia1512@gmail.com' THEN '15104679208'
    WHEN 'ventasarcangel1@gmail.com' THEN '573202954889'
    WHEN 'judacorps@gmail.com' THEN '118173740527'
    WHEN 'loreje28@gmail.com' THEN '573113073948'
    WHEN 'mariatmc.19@gmail.com' THEN '573106255998'
    WHEN 'angelatorresm@gmail.com' THEN '573204493528'
    WHEN 'juancarlos0006@gmail.com' THEN '573214877190'
    WHEN 'kathemrealestate7@gmail.com' THEN '573028646596'
    WHEN 'amoblandotusideas@gmail.com' THEN '573006881618'
    WHEN 'julher1124@hotmail.com' THEN '573158525386'
    WHEN 'pabloog979899@gmail.com' THEN '573217843390'
    WHEN 'marianaandrebanol@gmail.com' THEN '573217527016'
    WHEN 'iliana.inca@gmail.com' THEN '593984663178'
    WHEN 'st.correa93@gmail.com' THEN '573232009900'
    WHEN 'mayerlyn.suarez@gmail.com' THEN '524427166733'
    WHEN 'dazaw7@gmail.com' THEN '573505350508'
    WHEN 'astridcarooficial.negocios@gmail.com' THEN '573205154058'
    WHEN 'fgrleilani@aol.com' THEN '14079826009'
    WHEN 'moniburgueno8@gmail.com' THEN '14808881805'
    WHEN 'harold.caro29@gmail.com' THEN '573226799296'
    WHEN 'leslieromero2020@gmail.com' THEN '17327446869'
    WHEN 'larisa.stifiuc@gmail.com' THEN '34623447245'
    WHEN 'vivi.gallego.com@gmail.com' THEN '573005124370'
    WHEN 'marimil.pj@gmail.com' THEN '573054121095'
    WHEN 'alexacorreajaramillo@gmail.com' THEN '573163520040'
    WHEN 'johannamoreano@hotmail.com' THEN '573127813990'
    WHEN 'acidopotente3@gmail.com' THEN '16153724537'
    WHEN 'kubantmllc@gmail.com' THEN '13234940762'
    WHEN 'juantorres101705@gmail.com' THEN '573242673698'
    WHEN 'juliquicenoo@gmail.com' THEN '573002142811'
    WHEN 'kevin.trafficker.digital@gmail.com' THEN '573225912298'
    WHEN 'tecnofrutales@gmail.com' THEN '573128607186'
    WHEN 'andii.tostado@gmail.com' THEN '525567083336'
    WHEN 'camilonetworking982@gmail.com' THEN '573154240846'
    WHEN 'cablejireh@gmail.com' THEN '117723425825'
    WHEN 'euroxbarber@gmail.com' THEN '573232331935'
    WHEN 'isabellasanchezgomez99@gmail.com' THEN '573144736516'
    WHEN 'nikoaleja2609@gmail.com' THEN '573045258259'
    WHEN 'dbbermudezs@gmail.com' THEN '573043360451'
    WHEN 'luza606@msn.com' THEN '573017697175'
    ELSE buyer_phone END
WHERE buyer_email IN ('akire1784@hotmail.com', 'angieepa19@gmail.com', 'angelaordonez1234@gmail.com', 'lindawongvillacis@yahoo.es', 'karenfuxion24@gmail.com', 'maye.t.gomez@hotmail.com', 'marypatry54@hotmail.com', 'gonzalez.jek@gmail.com', 'robertojose032019@gmail.com', 'carlosfabianrojas10@hotmail.com', 'limalemu@gmail.com', 'fragancee8@gmail.com', 'yuriprojas@yahoo.es', 'mxzonestore@gmail.com', 'andresfella@hotmail.com', 'carolina.blanco@velawhite.com', 'ricardopinilla9@hotmail.com', 'jjairo171@gmail.com', 'studiolombaitcorp@gmail.com', 'wilopupilo@gmail.com', 'carolinarueda1608@gmail.com', 'lgjohana10@gmail.com', 'guzceballos1@gmail.com', 'patosandy2711@gmail.com', 'mardiazin@gmail.com', 'soniavera38@gmail.com', 'laucanina@outlook.com', 'shepard.ohonsi.sob@gmail.com', 'zullyalejandra@gmail.com', 'addys2353@gmail.com', 'danielaospinarmodel@gmail.com', 'leidymillan23@gmail.com', 'daniroman27@hotmail.com', 'nana_saldarriaga@hotmail.com', 'gerencia.idh@gmail.com', 'nunezyasira88@gmail.com', 'gutierrezclady@gmail.com', 'amorenoc100@yahoo.es', 'cursos@markiany.com', 'mpiedrahitagutierrez@gmail.com', 'jjcolorador@gmail.com', 'pepitoperez007@protonmail.com', 'pangeabeer@gmail.com', 'linalotteart@gmail.com', 'bajosusalasarte@gmail.com', 'familiaalexaspa@gmail.com', 'dramosyarleque@gmail.com', 'pipe_duque@hotmail.com', 'deyarubio@gmail.com', 'blendysramos@gmail.com', 'prisvivarv@gmail.com', 'isahh25@gmail.com', 'remolinaalbert@gmail.com', 'mazzarelli2017@gmail.com', 'giovanni.alf.mar@gmail.com', 'gabo71136244@gmail.com', 'bibianita12@hotmail.com', 'harrymdigital@outlook.com', 'marcelastefany9@gmail.com', 'holy.interiorfemenino@gmail.com', 'xiomyhenao18@hotmail.es', 'lilipod12@hotmail.com', 'lpablo59@gmail.com', 'pilotoguerrero281@gmail.com', 'infolizhernandez@gmail.com', 'christianleoval@hotmail.com', 'carolina.tabarez.ct@gmail.com', 'mad6812@gmail.com', 'infomeliospinacocinacocina@gmail.com', 'csmafra@gmail.com', 'qdenisse@gmail.com', 'velagiraldo@gmail.com', 'pattylunadr@gmail.com', 'katelonga@hotmail.com', 'docabreras.pe@gmail.com', 'jess0235marketing@gmail.com', 'andrewzerva0903@gmail.com', 'mariana.valenciac@autonoma.edu.co', 'johsef4dmrs@gmail.com', 'zapataduberandres@gmail.com', 'sebastianlondonoj@gmail.com', 'andresgiraldo325@gmail.com', 'hassel.ortegapelaez@gmail.com', 'jamerq.91@gmail.com', 'brayangonzalesmejia321@gmail.com', 'perla_87743@hotmail.com', 'germancorreamarin@gmail.com', 'gcamachoh95@gmail.com', 'yureesly1981@gmail.com', 'cardonacami29@gmail.com', 'pedropaucar37@gmail.com', 'lissoexpresvip@gmail.com', 'emprendeconalexa@gmail.com', 'anndres903@gmail.com', 'laagmvz@gmail.com', 'dianapatriciaca@gmail.com', 'angel.aycardi@outlook.com', 'jamesvdigital@gmail.com', 'juanjo.0121@outlook.com', 'dianatristancholache@gmail.com', 'nomadasdecorazontravel@gmail.com', 'sallymay08@hotmail.com', 'diani.sierra@yahoo.com', 'erikaplatas01@gmail.com', 'fafr81294@gmail.com', 'gabiuss25@hotmail.com', 'fabiolaandueza@gmail.com', 'adrianapramirezo@hotmail.com', 'beatrizhernandezc1@gmail.com', 'armoventas.atencion@gmail.com', 'sayu.cantillo@gmail.com', 'raquelramirez15@gmail.com', '2dfavilla@gmail.com', 'benja.flores.bta@gmail.com', 'lilianahl@icloud.com', 'jasipachano@gmail.com', 'fager777@gmail.com', 'maribel.bellisima501@gmail.com', 'yanurca_90@hotmail.com', 'paolarodriguezrealtor@gmail.com', 'ariess1986@gmail.com', 'aleja_9910_@hotmail.com', 'yuland8825@hotmail.com', 'danielaramirez.9394@gmail.com', 'patriciadoncel@gmail.com', 'ceo.harleycardozo@gmail.com', 'deiviaguillon15@gmail.com', 'lasgordas07@gmail.com', 'biancamga1981@gmail.com', 'emmanuellaraosorio@gmail.com', 'dayajuanes@gmail.com', 'lozanitoml@gmail.com', 'cordobajehiver@gmail.com', 'francisco16.murilloz@gmail.com', 'david_cardona16@hotmail.com', 'tomasina2718@yahoo.com', 'cryptonano18@gmail.com', 'luisamanriquebarrera1995@gmail.com', 'jorgedavidqw@gmail.com', 'juliajimenezarr@gmail.com', 'kam.cuervo@gmail.com', 'yaime71@yahoo.com', 'tomasm235@gmail.com', 'anamjaramillov@gmail.com', 'tatisuarez593@gmail.com', 'kevin.valenzuela000@gmail.com', 'gabrielriveravillamizar@gmail.com', 'carlos.bismarck36@gmail.com', 'cyn.pr16@hotmail.com', 'dianita1809@hotmail.com', 'paolatca@yahoo.com', 'andresredmusic@gmail.com', 'yefersonandreshernandez1@gmail.com', 'zulma_kmc92@hotmail.com', 'hotmartcmc@gmail.com', 'cagd2000@gmail.com', 'alexandramazuerarealtor@gmail.com', 'vanidadybelleza@hotmail.com', 'fernandorangel261121@gmail.com', 'piguasbebes@gmail.com', 'abigailgarcia1512@gmail.com', 'ventasarcangel1@gmail.com', 'judacorps@gmail.com', 'loreje28@gmail.com', 'mariatmc.19@gmail.com', 'angelatorresm@gmail.com', 'juancarlos0006@gmail.com', 'kathemrealestate7@gmail.com', 'amoblandotusideas@gmail.com', 'julher1124@hotmail.com', 'pabloog979899@gmail.com', 'marianaandrebanol@gmail.com', 'iliana.inca@gmail.com', 'st.correa93@gmail.com', 'mayerlyn.suarez@gmail.com', 'dazaw7@gmail.com', 'astridcarooficial.negocios@gmail.com', 'fgrleilani@aol.com', 'moniburgueno8@gmail.com', 'harold.caro29@gmail.com', 'leslieromero2020@gmail.com', 'larisa.stifiuc@gmail.com', 'vivi.gallego.com@gmail.com', 'marimil.pj@gmail.com', 'alexacorreajaramillo@gmail.com', 'johannamoreano@hotmail.com', 'acidopotente3@gmail.com', 'kubantmllc@gmail.com', 'juantorres101705@gmail.com', 'juliquicenoo@gmail.com', 'kevin.trafficker.digital@gmail.com', 'tecnofrutales@gmail.com', 'andii.tostado@gmail.com', 'camilonetworking982@gmail.com', 'cablejireh@gmail.com', 'euroxbarber@gmail.com', 'isabellasanchezgomez99@gmail.com', 'nikoaleja2609@gmail.com', 'dbbermudezs@gmail.com', 'luza606@msn.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'egaleano2827@gmail.com' THEN '573126401886'
    WHEN 'wladdys1313@gmail.com' THEN '5930984054785'
    WHEN 'ginanataliasoto@outlook.com' THEN '573104234197'
    WHEN 'danielabecerril.diseno@gmail.com' THEN '525514876471'
    WHEN 'linacorrea93@hotmail.com' THEN '118636772088'
    WHEN 'andreasabando@icloud.com' THEN '5930999768295'
    WHEN 'elilorojas@yahoo.com' THEN '573206036160'
    WHEN 'jeffersonperico1993@gmail.com' THEN '573052958797'
    WHEN 'dbalcazar@uees.edu.ec' THEN '5930999758892'
    WHEN 'evelyniza1995@gmail.com' THEN '573175633124'
    WHEN 'alexgcanog1@gmail.com' THEN '573242366011'
    WHEN 'dacore99999@gmail.com' THEN '573207167950'
    WHEN 'mayerli1205@gmail.com' THEN '573113433934'
    WHEN 'diamogo21@hotmail.com' THEN '573148278102'
    WHEN 'anama_eraso@hotmail.com' THEN '573178595220'
    WHEN 'alejasegundacuenta2@gmail.com' THEN '573124041225'
    WHEN 'moreno_t_a@hotmail.com' THEN '523312510180'
    WHEN 'lululoaiza@gmail.com' THEN '573003074733'
    WHEN 'juli.mendoza.jam@gmail.com' THEN '18019280053'
    WHEN 'ccamilo.molina@gmail.com' THEN '573237777461'
    WHEN 'alejandragrues@gmail.com' THEN '573123495375'
    WHEN 'lucecitamejiabaron@gmail.com' THEN '12039069751'
    WHEN 'doradasbypaolaortiz@gmail.com' THEN '573150604468'
    WHEN 'clio333@hotmail.com' THEN '573108231536'
    WHEN 'angiepala@hotmail.com' THEN '573206719293'
    WHEN 'luoneelop@hotmail.com' THEN '19092681354'
    WHEN 'danieldonado690@gmail.com' THEN '573127779472'
    WHEN 'cristianarango0610@gmail.com' THEN '573028426307'
    WHEN 'pilarbernal08@gmail.com' THEN '573102844675'
    WHEN 'kellyh1093@gmail.com' THEN '573135356590'
    WHEN 'celeste@aicca.com.mx' THEN '525563172786'
    WHEN 'marketingbydvg@gmail.com' THEN '19294207680'
    WHEN 'sebastianmontes6@gmail.com' THEN '573114218571'
    WHEN 'pymeza@gmail.com' THEN '527227116586'
    WHEN 'bryan.jaimes24@gmail.com' THEN '573137445857'
    WHEN 'mia8693@gmail.com' THEN '523339561340'
    WHEN 'tatianadiezmalagon@gmail.com' THEN '525549651420'
    WHEN 'jwalda91@gmail.com' THEN '50246008228'
    WHEN 'sebasmc599@gmail.com' THEN '573007624046'
    WHEN 'joseval30@yahoo.com' THEN '5930991990977'
    WHEN 'danangarital@gmail.com' THEN '573186610755'
    WHEN 'cere0720@gmail.com' THEN '113477771714'
    WHEN 'ceregalado68@gmail.com' THEN '113477771714'
    WHEN 'infoclaravelasquez@gmail.com' THEN '573115529352'
    WHEN 'anyelina84@hotmail.com' THEN '573156735824'
    WHEN 'cedaacmx@gmail.com' THEN '527828889820'
    WHEN 'jdlopezdu@gmail.com' THEN '17043963485'
    WHEN 'paca993@hotmail.com' THEN '573116461874'
    WHEN 'lemosky94@gmail.com' THEN '573185287540'
    WHEN 'luismaquesadaborrero@gmail.com' THEN '12104007234'
    WHEN 'destebanmartinez@icloud.com' THEN '573209152101'
    WHEN 'luzstelladuce@gmail.com' THEN '573133869389'
    WHEN 'pasifico@gmail.com' THEN '19807779354'
    WHEN 'alerojasarizaga@gmail.com' THEN '524613462168'
    WHEN 'berdaju2012@gmail.com' THEN '573134109853'
    WHEN 'cordobakettyyohana@gmail.com' THEN '573226747868'
    WHEN 'juliethleslie049@gmail.com' THEN '573128462945'
    WHEN 'fercastro.rico@gmail.com' THEN '573212255839'
    WHEN 'dalazu0717@gmail.com' THEN '573156157717'
    WHEN 'subgerenciaconexiontrip@gmail.com' THEN '573117363187'
    WHEN 'claudianailstx@gmail.com' THEN '17542731793'
    WHEN 'ftalejandragomez@gmail.com' THEN '573104160754'
    WHEN 'daniigomez08@gmail.com' THEN '573104257837'
    WHEN 'vallejo_7906@hotmail.com' THEN '573213764052'
    WHEN 'laurahurtado_2018@hotmail.com' THEN '573107948191'
    WHEN 'gamana2809@gmail.com' THEN '17274323890'
    WHEN 'ypr-11@hotmail.com' THEN '573214687298'
    WHEN 'mariatutyaccesorios@gmail.com' THEN '573105673136'
    WHEN 'cropmark@me.com' THEN '525550733773'
    WHEN 'caritorincon@gmail.com' THEN '573103432788'
    WHEN 'juanramonpro@gmail.com' THEN '51970725439'
    WHEN 'gabymu1855@gmail.com' THEN '573138995315'
    WHEN 'cqg237@gmail.com' THEN '573176013135'
    WHEN 'susipulga23@gmail.com' THEN '573052504884'
    WHEN 'andrecastello@gmail.com' THEN '593984693430'
    WHEN 'noashopfl@gmail.com' THEN '19046318023'
    WHEN 'santanderbarraza@gmail.com' THEN '573005537278'
    WHEN 'kromaticadesign@gmail.com' THEN '573152470355'
    WHEN 'barbosaperezalejandra@gmail.com' THEN '573174027633'
    WHEN 'valenti1903@hotmail.com' THEN '573113396026'
    WHEN 'ana.roldantv@gmail.com' THEN '573006100797'
    WHEN 'caicedo.orrego17@gmail.com' THEN '573167092195'
    WHEN 'malejagalo3@gmail.com' THEN '573104753563'
    WHEN 'visionbloomstudio@gmail.com' THEN '112517532998'
    WHEN 'germandelgadotoledo@gmail.com' THEN '573104199547'
    WHEN 'castanedanicolas08@gmail.com' THEN '573052991289'
    WHEN 'bubalulajey@gmail.com' THEN '573164722696'
    WHEN '1993marcela.rios@gmail.com' THEN '573014888981'
    WHEN 'luisalinasrealestatemarketing@gmail.com' THEN '113233654847'
    WHEN 'vegonio276@gmail.com' THEN '573163682817'
    WHEN 'soarisnovarealtor@gmail.com' THEN '18138935382'
    WHEN 'aprendecompartiendo2022@gmail.com' THEN '13013265555'
    WHEN 'v_valdes@outlook.com' THEN '573162213685'
    WHEN 'adri.camargo84@gmail.com' THEN '14075762800'
    WHEN 'diegopoveda09@gmail.com' THEN '5930992731464'
    WHEN 'maleja.pv0209@gmail.com' THEN '573153868151'
    WHEN 'jussie121@gmail.com' THEN '573116125119'
    WHEN 'cristhian.p1994@gmail.com' THEN '573014596298'
    WHEN 'sorocaimask8@gmail.com' THEN '573015304354'
    WHEN 'tobonjudy@gmail.com' THEN '573504963460'
    WHEN 'karlasanabria@yahoo.es' THEN '573015837700'
    WHEN 'lizethduran0321@hotmail.com' THEN '573105008063'
    WHEN 'arq.jcjimenez0@gmail.com' THEN '573213162803'
    WHEN 'paugonzalezg2017@hotmail.com' THEN '573188042969'
    WHEN 'paulaandreajimenezruiz@gmail.com' THEN '573013850912'
    WHEN 'rcsepulveda4@gmail.com' THEN '50254826023'
    WHEN 'betancourt.oje@gmail.com' THEN '573222436044'
    WHEN 'betancourthbo@gmail.com' THEN '573022629299'
    WHEN 'justine14_7@hotmail.com' THEN '5930995748669'
    WHEN 'lideres365global@gmail.com' THEN '593990369791'
    WHEN 'angelikco09@gmail.com' THEN '573113839830'
    WHEN 'mateo3329edinsonkate@gmail.com' THEN '573046351210'
    WHEN 'juanselomo@gmail.com' THEN '573015486700'
    WHEN 'norisrangel2017@gmail.com' THEN '573145364462'
    WHEN 'heidy.digital@gmail.com' THEN '573187441178'
    WHEN 'santiaristi_1994@hotmail.com' THEN '573183050370'
    WHEN 'andre1726_@hotmail.com' THEN '573133872078'
    WHEN 'milen256@gmail.com' THEN '573122329420'
    WHEN 'adrianarp06@hotmail.com' THEN '573162238883'
    WHEN 'klminorta@gmail.com' THEN '573232336565'
    WHEN 'cruzjohana027@gmail.com' THEN '573145089420'
    WHEN 'ramirezlam80@gmail.com' THEN '522282298629'
    WHEN 'rdavid.mendoza.j@gmail.com' THEN '524434652008'
    WHEN 'adri.bulla16@hotmail.com' THEN '573102906736'
    WHEN 'apps@pablodice.mx' THEN '526671855039'
    WHEN 'milenagomezarcila@gmail.com' THEN '573016167171'
    WHEN 'patriciacamelo10@gmail.com' THEN '18134246314'
    WHEN 'ericklef@hotmail.com' THEN '13056273474'
    WHEN 'juandlondono27@gmail.com' THEN '573148631231'
    WHEN 'mile.h.g@hotmail.com' THEN '573156162249'
    WHEN 'angelicarod24@gmail.com' THEN '13475244770'
    WHEN 'meli.palacio73@gmail.com' THEN '119294317767'
    WHEN 'oszysalazar@gmail.com' THEN '17864198139'
    WHEN 'nataliapastran494@gmail.com' THEN '19549977397'
    WHEN 'stefy_0523@hotmail.com' THEN '573214458684'
    WHEN 'zerolatitude.ms@gmail.com' THEN '16469961579'
    WHEN 'admicompramas@gmail.com' THEN '573185312170'
    WHEN 'jcorredor82@gmail.com' THEN '573202324707'
    WHEN 'ielvanvan97@gmail.com' THEN '573233140545'
    WHEN 'catanoclavijod@gmail.com' THEN '573059468602'
    WHEN 'ansato23@gmail.com' THEN '573117179466'
    WHEN 'jma9974@gmail.com' THEN '573113746732'
    WHEN 'andresdavid.garciam@gmail.com' THEN '573196050295'
    WHEN 'castri-llon@hotmail.com' THEN '573006391464'
    WHEN 'yanethroam@hotmail.com' THEN '573202049026'
    WHEN 'isandigital2024@gmail.com' THEN '573008147387'
    WHEN 'catyriveras@gmail.com' THEN '573137120934'
    WHEN 'dianicuerv07@gmail.com' THEN '573214907628'
    WHEN 'coronado_karl@hotmail.com' THEN '525513924025'
    WHEN 'andrea_sierra16@hotmail.com' THEN '573112559951'
    WHEN 'gmgempresas.com@gmail.com' THEN '573232849527'
    WHEN 'do72353@gmail.com' THEN '573158914145'
    WHEN 'lele-sanchex1@hotmail.com' THEN '573208199089'
    WHEN 'tradingymas2023@gmail.com' THEN '34673165088'
    WHEN 'dylanincrease@gmail.com' THEN '528444980359'
    WHEN 'jximenar1112@gmail.com' THEN '573213598191'
    WHEN 'info@marcerrealtor.com' THEN '14079903450'
    WHEN 'francinethemprende@gmail.com' THEN '573023179099'
    WHEN 'marugr.sinergia@gmail.com' THEN '593984248238'
    WHEN 'leidixxita-@hotmail.com' THEN '573124696268'
    WHEN 'geralgonzalez2120@hotmail.com' THEN '573107668619'
    WHEN 'nicoleorejuela@icloud.com' THEN '5930981724434'
    WHEN 'luciannohill@gmail.com' THEN '573165361090'
    WHEN 'maribel311216@gmail.com' THEN '573001353534'
    WHEN 'leydypaolagarciacelys1994@gmail.com' THEN '573112643982'
    WHEN 'katerinemorales1731@gmail.com' THEN '573166449602'
    WHEN 'valesm09@hotmail.com' THEN '573506799441'
    WHEN 'crushcalderon635@gmail.com' THEN '16083987131'
    WHEN 'kattygutierrezr.gdh@gmail.com' THEN '5930996220150'
    WHEN 'angelik_mrm@hotmail.com' THEN '573112823774'
    WHEN 'marialegtz@gmail.com' THEN '573022319483'
    WHEN 'ujohana@hotmail.com' THEN '573146323892'
    WHEN 'anita.erira12@gmail.com' THEN '573178638925'
    WHEN 'obethcelio29@gmail.com' THEN '51912842715'
    WHEN 'tatilamprea02@gmail.com' THEN '573183373946'
    WHEN 'tativ215@gmail.com' THEN '573138866792'
    WHEN 'antovalencia12@hotmail.com' THEN '593987146108'
    WHEN 'jennifer_wk@yahoo.com.co' THEN '573103047553'
    WHEN 'smmb24@gmail.com' THEN '573008909686'
    WHEN 'juandaramirez1983@gmail.com' THEN '573006967776'
    WHEN 'marianaflorezu@gmail.com' THEN '573007246984'
    WHEN 'agenciatravelsai@gmail.com' THEN '5713214094508'
    WHEN 'vivianagiraldop85@gmail.com' THEN '51933592688'
    WHEN 'estefania_2709@hotmail.com' THEN '573104954807'
    WHEN 'nurypacheco25@hotmail.com' THEN '573172451357'
    WHEN 'andreaherrera8921@gmail.com' THEN '117204837683'
    WHEN 'kimfloresv@gmail.com' THEN '51932374536'
    WHEN 'luisavasquezcomunicadora@gmail.com' THEN '573233270116'
    WHEN 'gelatoitalianoartesanal@gmail.com' THEN '524341440924'
    WHEN 'perlanc.cursos@gmail.com' THEN '523312984009'
    WHEN 'stivenbl517@gmail.com' THEN '573218350631'
    WHEN 'miopticag.o@gmail.com' THEN '573214999531'
    WHEN 'rocketeamproducciones@gmail.com' THEN '573043432095'
    WHEN 'espinolafigueroajesusleonel@gmail.com' THEN '14075387085'
    WHEN 'alejandromedinaiin@gmail.com' THEN '573136242318'
    WHEN 'kevinmontesdeocarivas@gmail.com' THEN '573182422441'
    WHEN 'marthameru22@gmail.com' THEN '523881051843'
    WHEN 'mikealfonsomusic@gmail.com' THEN '573124181836'
    WHEN 'caenthi0502@gmail.com' THEN '34664199489'
    WHEN 'dannyluque123@gmail.com' THEN '573244556316'
    ELSE buyer_phone END
WHERE buyer_email IN ('egaleano2827@gmail.com', 'wladdys1313@gmail.com', 'ginanataliasoto@outlook.com', 'danielabecerril.diseno@gmail.com', 'linacorrea93@hotmail.com', 'andreasabando@icloud.com', 'elilorojas@yahoo.com', 'jeffersonperico1993@gmail.com', 'dbalcazar@uees.edu.ec', 'evelyniza1995@gmail.com', 'alexgcanog1@gmail.com', 'dacore99999@gmail.com', 'mayerli1205@gmail.com', 'diamogo21@hotmail.com', 'anama_eraso@hotmail.com', 'alejasegundacuenta2@gmail.com', 'moreno_t_a@hotmail.com', 'lululoaiza@gmail.com', 'juli.mendoza.jam@gmail.com', 'ccamilo.molina@gmail.com', 'alejandragrues@gmail.com', 'lucecitamejiabaron@gmail.com', 'doradasbypaolaortiz@gmail.com', 'clio333@hotmail.com', 'angiepala@hotmail.com', 'luoneelop@hotmail.com', 'danieldonado690@gmail.com', 'cristianarango0610@gmail.com', 'pilarbernal08@gmail.com', 'kellyh1093@gmail.com', 'celeste@aicca.com.mx', 'marketingbydvg@gmail.com', 'sebastianmontes6@gmail.com', 'pymeza@gmail.com', 'bryan.jaimes24@gmail.com', 'mia8693@gmail.com', 'tatianadiezmalagon@gmail.com', 'jwalda91@gmail.com', 'sebasmc599@gmail.com', 'joseval30@yahoo.com', 'danangarital@gmail.com', 'cere0720@gmail.com', 'ceregalado68@gmail.com', 'infoclaravelasquez@gmail.com', 'anyelina84@hotmail.com', 'cedaacmx@gmail.com', 'jdlopezdu@gmail.com', 'paca993@hotmail.com', 'lemosky94@gmail.com', 'luismaquesadaborrero@gmail.com', 'destebanmartinez@icloud.com', 'luzstelladuce@gmail.com', 'pasifico@gmail.com', 'alerojasarizaga@gmail.com', 'berdaju2012@gmail.com', 'cordobakettyyohana@gmail.com', 'juliethleslie049@gmail.com', 'fercastro.rico@gmail.com', 'dalazu0717@gmail.com', 'subgerenciaconexiontrip@gmail.com', 'claudianailstx@gmail.com', 'ftalejandragomez@gmail.com', 'daniigomez08@gmail.com', 'vallejo_7906@hotmail.com', 'laurahurtado_2018@hotmail.com', 'gamana2809@gmail.com', 'ypr-11@hotmail.com', 'mariatutyaccesorios@gmail.com', 'cropmark@me.com', 'caritorincon@gmail.com', 'juanramonpro@gmail.com', 'gabymu1855@gmail.com', 'cqg237@gmail.com', 'susipulga23@gmail.com', 'andrecastello@gmail.com', 'noashopfl@gmail.com', 'santanderbarraza@gmail.com', 'kromaticadesign@gmail.com', 'barbosaperezalejandra@gmail.com', 'valenti1903@hotmail.com', 'ana.roldantv@gmail.com', 'caicedo.orrego17@gmail.com', 'malejagalo3@gmail.com', 'visionbloomstudio@gmail.com', 'germandelgadotoledo@gmail.com', 'castanedanicolas08@gmail.com', 'bubalulajey@gmail.com', '1993marcela.rios@gmail.com', 'luisalinasrealestatemarketing@gmail.com', 'vegonio276@gmail.com', 'soarisnovarealtor@gmail.com', 'aprendecompartiendo2022@gmail.com', 'v_valdes@outlook.com', 'adri.camargo84@gmail.com', 'diegopoveda09@gmail.com', 'maleja.pv0209@gmail.com', 'jussie121@gmail.com', 'cristhian.p1994@gmail.com', 'sorocaimask8@gmail.com', 'tobonjudy@gmail.com', 'karlasanabria@yahoo.es', 'lizethduran0321@hotmail.com', 'arq.jcjimenez0@gmail.com', 'paugonzalezg2017@hotmail.com', 'paulaandreajimenezruiz@gmail.com', 'rcsepulveda4@gmail.com', 'betancourt.oje@gmail.com', 'betancourthbo@gmail.com', 'justine14_7@hotmail.com', 'lideres365global@gmail.com', 'angelikco09@gmail.com', 'mateo3329edinsonkate@gmail.com', 'juanselomo@gmail.com', 'norisrangel2017@gmail.com', 'heidy.digital@gmail.com', 'santiaristi_1994@hotmail.com', 'andre1726_@hotmail.com', 'milen256@gmail.com', 'adrianarp06@hotmail.com', 'klminorta@gmail.com', 'cruzjohana027@gmail.com', 'ramirezlam80@gmail.com', 'rdavid.mendoza.j@gmail.com', 'adri.bulla16@hotmail.com', 'apps@pablodice.mx', 'milenagomezarcila@gmail.com', 'patriciacamelo10@gmail.com', 'ericklef@hotmail.com', 'juandlondono27@gmail.com', 'mile.h.g@hotmail.com', 'angelicarod24@gmail.com', 'meli.palacio73@gmail.com', 'oszysalazar@gmail.com', 'nataliapastran494@gmail.com', 'stefy_0523@hotmail.com', 'zerolatitude.ms@gmail.com', 'admicompramas@gmail.com', 'jcorredor82@gmail.com', 'ielvanvan97@gmail.com', 'catanoclavijod@gmail.com', 'ansato23@gmail.com', 'jma9974@gmail.com', 'andresdavid.garciam@gmail.com', 'castri-llon@hotmail.com', 'yanethroam@hotmail.com', 'isandigital2024@gmail.com', 'catyriveras@gmail.com', 'dianicuerv07@gmail.com', 'coronado_karl@hotmail.com', 'andrea_sierra16@hotmail.com', 'gmgempresas.com@gmail.com', 'do72353@gmail.com', 'lele-sanchex1@hotmail.com', 'tradingymas2023@gmail.com', 'dylanincrease@gmail.com', 'jximenar1112@gmail.com', 'info@marcerrealtor.com', 'francinethemprende@gmail.com', 'marugr.sinergia@gmail.com', 'leidixxita-@hotmail.com', 'geralgonzalez2120@hotmail.com', 'nicoleorejuela@icloud.com', 'luciannohill@gmail.com', 'maribel311216@gmail.com', 'leydypaolagarciacelys1994@gmail.com', 'katerinemorales1731@gmail.com', 'valesm09@hotmail.com', 'crushcalderon635@gmail.com', 'kattygutierrezr.gdh@gmail.com', 'angelik_mrm@hotmail.com', 'marialegtz@gmail.com', 'ujohana@hotmail.com', 'anita.erira12@gmail.com', 'obethcelio29@gmail.com', 'tatilamprea02@gmail.com', 'tativ215@gmail.com', 'antovalencia12@hotmail.com', 'jennifer_wk@yahoo.com.co', 'smmb24@gmail.com', 'juandaramirez1983@gmail.com', 'marianaflorezu@gmail.com', 'agenciatravelsai@gmail.com', 'vivianagiraldop85@gmail.com', 'estefania_2709@hotmail.com', 'nurypacheco25@hotmail.com', 'andreaherrera8921@gmail.com', 'kimfloresv@gmail.com', 'luisavasquezcomunicadora@gmail.com', 'gelatoitalianoartesanal@gmail.com', 'perlanc.cursos@gmail.com', 'stivenbl517@gmail.com', 'miopticag.o@gmail.com', 'rocketeamproducciones@gmail.com', 'espinolafigueroajesusleonel@gmail.com', 'alejandromedinaiin@gmail.com', 'kevinmontesdeocarivas@gmail.com', 'marthameru22@gmail.com', 'mikealfonsomusic@gmail.com', 'caenthi0502@gmail.com', 'dannyluque123@gmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'cadete711@gmail.com' THEN '573184079261'
    WHEN 'sugey_1279@hotmail.com' THEN '573125343336'
    WHEN 'diegoupel35@gmail.com' THEN '584243424307'
    WHEN 'lauranicoll.chacon@gmail.com' THEN '573022408482'
    WHEN 'ajolon@gmail.com' THEN '50253010151'
    WHEN 'carvajalm295@gmail.com' THEN '573212703682'
    WHEN 'josemiguelfbz337@gmail.com' THEN '573117388183'
    WHEN 'jonathan.d.12@hotmail.com' THEN '573118012006'
    WHEN 'alvarez.pao@gmail.com' THEN '573003082232'
    WHEN 'mporritasg@gmail.com' THEN '573118359706'
    WHEN 'pardok94@gmail.com' THEN '573224544507'
    WHEN 'esperanza@ehopeusa.com' THEN '12393166751'
    WHEN 'jeniferisazaluna@gmail.com' THEN '573028549767'
    WHEN 'dianaarizam87@gmail.com' THEN '573113974590'
    WHEN 'karyviqueira@gmail.com' THEN '541149796095'
    WHEN 'susanabarahona21@gmail.com' THEN '573028067914'
    WHEN 'koke.macias@gmail.com' THEN '526319448651'
    WHEN 'sandraurqui1@gmail.com' THEN '573154846949'
    WHEN 'beraguirre@gmail.com' THEN '56992388751'
    WHEN 'activalamujer@hotmail.com' THEN '529989393309'
    WHEN 'jenniferquimbayo92@gmail.com' THEN '573002523226'
    WHEN 'cordovaalejandra29@gmail.com' THEN '525541301089'
    WHEN 'misabelvillar@hotmail.com' THEN '527773521232'
    WHEN 'gabriel.cifuentes.m@gmail.com' THEN '5930992738412'
    WHEN 'academy777lhm@gmail.com' THEN '573014221333'
    WHEN 'marielapollastrini18@gmail.com' THEN '14423726101'
    WHEN 'solucionmaldonado67@gmail.com' THEN '19852556877'
    WHEN 'kathy_sofi95@hotmail.com' THEN '51980176796'
    WHEN 'boriscometta27@gmail.com' THEN '573132330831'
    WHEN 'opticanewtonsa@gmail.com' THEN '573005544038'
    WHEN 'lauryrua95@gmail.com' THEN '573007896158'
    WHEN 'alberto_acosta1@hotmail.com' THEN '573188833566'
    WHEN 'nataliahl2010@hotmail.com' THEN '573116511890'
    WHEN 'topteninmobiliaria55@gmail.com' THEN '525298438506'
    WHEN 'pablocelis11@gmail.com' THEN '573182669762'
    WHEN 'karendiazm@hotmail.com' THEN '573125103296'
    WHEN 'hoyosjeimy96@gmail.com' THEN '573235413045'
    WHEN 'yeshuarodriguezsilva@gmail.com' THEN '525581204019'
    WHEN 'xp.yar4@gmail.com' THEN '59169888518'
    WHEN 'adoariza05@gmail.com' THEN '19372503165'
    WHEN 'jorgefilmmaking@gmail.com' THEN '573104013025'
    WHEN 'caroll91rodriguez@gmail.com' THEN '117707659637'
    WHEN 'gercysimet8@gmail.com' THEN '19293842085'
    WHEN 'dimaleva_58@hotmail.com' THEN '573115817242'
    WHEN 'camiloandresp19@hotmail.com' THEN '573106821329'
    WHEN 'banuelosmd@gmail.com' THEN '523314271361'
    WHEN 'tarangoplay@gmail.com' THEN '573173662555'
    WHEN 'andreaceh16@gmail.com' THEN '573046528230'
    WHEN 'alejo20j@gmail.com' THEN '573216074698'
    WHEN 'vivianasamaniego1283@gmail.com' THEN '573161868652'
    WHEN 'rbnguillermo@gmail.com' THEN '51958232512'
    WHEN 'santyadss@gmail.com' THEN '573205832381'
    WHEN 'biscuerobayo@hotmail.com' THEN '573226864242'
    WHEN 'andrea@andreaodle.com' THEN '16617091497'
    WHEN 'acuerdosfinancierosldc@gmail.com' THEN '573218391103'
    WHEN 'steffy.veliz23@gmail.com' THEN '13855296273'
    WHEN 'coordinacioneventosvictoria@gmail.com' THEN '573176994066'
    WHEN 'jefferson.marben10@gmail.com' THEN '573116085130'
    WHEN 'kte-navarro@hotmail.com' THEN '573104657741'
    WHEN 'paulitha3110@gmail.com' THEN '573215705302'
    WHEN 'angelacusco2019@gmail.com' THEN '51958192800'
    WHEN 'gromit4800@gmail.com' THEN '525663720279'
    WHEN 'hmolanopatino@gmail.com' THEN '573012061436'
    WHEN 'armandochazari@gmail.com' THEN '14259037534'
    WHEN 'brepaca725@gmail.com' THEN '573169369763'
    WHEN 'jenny.povedar@gmail.com' THEN '573212723732'
    WHEN 'ceojairoavalos@gmail.com' THEN '525625294651'
    WHEN 'lozano_702@hotmail.com' THEN '528123330440'
    WHEN 'adricaballero10@hotmail.com' THEN '573102822746'
    WHEN 'sebasrojasm@gmail.com' THEN '573137433478'
    WHEN 'nicolshopiavanegasarenas@gmail.com' THEN '573222352510'
    WHEN 'sindyanez05@gmail.com' THEN '573016237237'
    WHEN 'lore.leon2412@gmail.com' THEN '573225875438'
    WHEN 'info@samuelfranco.com' THEN '573153113232'
    WHEN 'gustavoguerraventas@gmail.com' THEN '573133224392'
    WHEN 'opt.a_armendariz@outlook.com' THEN '5930996258531'
    WHEN 'asanchezp1974@gmail.com' THEN '56975395383'
    WHEN 'concejalnicolas@gmail.com' THEN '573184042381'
    WHEN 'modebonilla@cococreativo.com.mx' THEN '522281731761'
    WHEN 'anagaviriar05@gmail.com' THEN '573022542072'
    WHEN 'm.jair2819@gmail.com' THEN '573123178293'
    WHEN 'sxmauroxe@gmail.com' THEN '573225134997'
    WHEN 'jart85@gmail.com' THEN '573042441106'
    WHEN 'jmendezcalle@yahoo.com' THEN '593958647103'
    WHEN 'gerencia@atiempo.com.ec' THEN '593988985500'
    WHEN 'bluagencia2021@gmail.com' THEN '573125883339'
    WHEN 'glendafernandez777@icloud.com' THEN '573106087542'
    WHEN 'cpn.hugosolalinde@gmail.com' THEN '595975485392'
    WHEN 'gomezmilena781@gmail.com' THEN '573128867937'
    WHEN 'felipedr161@hotmail.com' THEN '573108671712'
    WHEN 'jhonyquevedo@gmail.com' THEN '573204792521'
    WHEN 'alojah83@gmail.com' THEN '19146022108'
    WHEN 'marceco1975@hotmail.com' THEN '573217294172'
    WHEN 'hernandezmartinezalexis@gmail.com' THEN '573112307733'
    WHEN 'caprietos@yahoo.com' THEN '573116007486'
    WHEN 'lizeth27642@hotmail.com' THEN '573102962419'
    WHEN 'sebastianrc15.2@gmail.com' THEN '524191562539'
    WHEN 'hortensia@encasapanama.com' THEN '50760914187'
    WHEN 'lewistrp@gmail.com' THEN '573116962961'
    WHEN 'diana19484@hotmail.com' THEN '5930939077389'
    WHEN 'osiris1323@yahoo.com' THEN '527224587632'
    WHEN 'denegociosco@gmail.com' THEN '573153540285'
    WHEN 'aleparraduque@gmail.com' THEN '573216044646'
    WHEN 'paulaguarnido15@gmail.com' THEN '542645081467'
    WHEN 'juanpablo.g@solucioneseducativastc.com' THEN '5930998345612'
    WHEN 'henryquilind58@gmail.com' THEN '573001349138'
    WHEN 'johan078colombia@hotmail.com' THEN '573006466946'
    WHEN 'jcamiloaga@gmail.com' THEN '51966786221'
    WHEN 'dianalucia2021@yahoo.com' THEN '573162824755'
    WHEN 'jmalvarez@catalizando.com' THEN '17868458828'
    WHEN 'lauravanessa.marquezc@gmail.com' THEN '573212364132'
    WHEN 'rlgladys258@gmail.com' THEN '573002489514'
    WHEN 'drgarcia.emprende@gmail.com' THEN '50660192493'
    WHEN 'tefagomez.art@gmail.com' THEN '573158026471'
    WHEN 'andres7max@gmail.com' THEN '573187151864'
    WHEN 'ger061136@gmail.com' THEN '573215751860'
    WHEN 'tomassisa72@gmail.com' THEN '573128013063'
    WHEN 'caprichosspa2019@gmail.com' THEN '573214379408'
    WHEN 'jorgerodriguezinvestment@gmail.com' THEN '19499663623'
    WHEN 'josegplazas@gmail.com' THEN '573008173434'
    WHEN 'dropshippingecommercemastery@gmail.com' THEN '573183889957'
    WHEN 'morenoricardo848@gmail.com' THEN '573175406827'
    WHEN 'oscarmau1@outlook.com' THEN '573213353561'
    WHEN 'marthaostios@hotmail.com' THEN '593995071106'
    WHEN 'impulsa_markting1.0@gmail.com' THEN '573196209866'
    WHEN 'saavedra.ro75@gmail.com' THEN '51975356830'
    WHEN 'kevinfpa1406@gmail.com' THEN '573108352138'
    WHEN 'sanchez_laura.h@hotmail.com' THEN '573222822505'
    WHEN 'heiber025@gmail.com' THEN '573002975058'
    WHEN 'eventosclubdecampolipangue@gmail.com' THEN '56988329799'
    WHEN 'euvivolavida@hotmail.com' THEN '573175577427'
    WHEN 'lizbethdvand@gmail.com' THEN '573246433848'
    WHEN 'yurani2102jeronimo@gmail.com' THEN '573108354852'
    WHEN 'duqueandrea079@gmail.com' THEN '573146649111'
    WHEN 'fabian.gacosta@gmail.com' THEN '573133202100'
    WHEN 'danimosidj@gmail.com' THEN '573103357439'
    WHEN 'andres580357@gmail.com' THEN '573124249406'
    WHEN 'celecomunica@gmail.com' THEN '573012351782'
    WHEN 'yuryjimenez@gmail.com' THEN '573007795209'
    WHEN 'behappynailscl@gmail.com' THEN '56961447426'
    WHEN 'marketingllado@gmail.com' THEN '573122655647'
    WHEN 'joelmejia708@gmail.com' THEN '51981753369'
    WHEN 'kristhina39@hotmail.com' THEN '573234632921'
    WHEN 'santicada@gmail.com' THEN '573103329304'
    WHEN 'rauljtorres18@gmail.com' THEN '51952106194'
    WHEN 'elpandaaoficial@gmail.com' THEN '573219282885'
    WHEN 'jackfalvarado@gmail.com' THEN '573165366015'
    WHEN 'daniela.ortizmedia@gmail.com' THEN '573146523709'
    WHEN 'alejandroartis495@gmail.com' THEN '573227229800'
    WHEN 'icristina_perezv@hotmail.com' THEN '593984692168'
    WHEN 'kmbmarketing01@gmail.com' THEN '573017010008'
    WHEN 'milezagi@gmail.com' THEN '573218797889'
    WHEN 'karolinaochoa.ag@gmail.com' THEN '573046600022'
    WHEN 'jdanielrl@gmail.com' THEN '51940502844'
    WHEN 'lizmanriqueugc@gmail.com' THEN '573117845634'
    WHEN 'sandramilenaescobar@hotmail.com' THEN '573108493687'
    WHEN 'luferpsicologadigital@gmail.com' THEN '573136861136'
    WHEN 'fitnessjeikmart@gmail.com' THEN '573104030814'
    WHEN 'estheladuchesalazar@gmail.com' THEN '59339823664'
    WHEN 'coloreartumente@gmail.com' THEN '573185212402'
    WHEN 'unasgotasmagicas@gmail.com' THEN '573154897893'
    WHEN 'andresmape1991@gmail.com' THEN '573228539992'
    WHEN 'ovalle.vanessa@gmail.com' THEN '16309011444'
    WHEN 'clauloc@outlook.com' THEN '525622165389'
    WHEN 'gokuygohan9999@gmail.com' THEN '573017871563'
    WHEN 'memero86@gmail.com' THEN '593998040473'
    WHEN 'luis.feernandog@gmail.com' THEN '573177001139'
    WHEN 'angelikbp45@gmail.com' THEN '573204780251'
    WHEN 'claudiaaserna@hotmail.com' THEN '526871169236'
    WHEN 'contactomagentaxv@gmail.com' THEN '529511167805'
    WHEN 'mkarmengl@hotmail.com' THEN '522221836002'
    WHEN 'cindysilvajesus8@gmail.com' THEN '12096290560'
    WHEN 'carlosbuitrago1992@hotmail.com' THEN '573044817003'
    WHEN 'kaorimurasaki205@gmail.com' THEN '525574950097'
    WHEN 'edwar31mejia@gmail.com' THEN '573164584700'
    WHEN 'lejarazu86@gmail.com' THEN '56935614810'
    WHEN 'maymont6212@gmail.com' THEN '525566128895'
    WHEN 'gifagomu1986@gmail.com' THEN '573206429839'
    WHEN 'johamarketing@gmail.com' THEN '17864796101'
    WHEN 'cohencaceres@gmail.com' THEN '5950981445146'
    WHEN 'lanishellw@hotmail.com' THEN '573208590532'
    WHEN 'narusanarusewawa@gmail.com' THEN '523141065544'
    WHEN 'marisolenriquez0101@gmail.com' THEN '12255730942'
    WHEN 'carlosballesteros777@hotmail.com' THEN '573145807529'
    WHEN 'cris_david97@hotmail.com' THEN '5930981291917'
    WHEN 'creativo@erickraw.page' THEN '573054150129'
    WHEN 'dianajarangoa@gmail.com' THEN '17866220677'
    WHEN 'pilar.sanchez1919@gmail.com' THEN '573145616151'
    WHEN 'alfredodelcastillo511@gmail.com' THEN '19296089388'
    WHEN 'rodrigoospino@hotmail.com' THEN '573016658288'
    WHEN 'tatianavargas026@gmail.com' THEN '573202653982'
    WHEN 'mercadeoglobalvitality@gmail.com' THEN '573178549895'
    WHEN 'vibesbgta@gmail.com' THEN '573204155733'
    WHEN 'maikolquintero20@gmail.com' THEN '573006421199'
    WHEN 'toutsurlemarketingdereseau@gmail.com' THEN '525566568324'
    WHEN 'lauravierab@gmail.com' THEN '573147453046'
    WHEN 'erickarnulfo2@gmail.com' THEN '529982443235'
    WHEN 'lisandrapi1986@gmail.com' THEN '117864736025'
    WHEN 'ovejares@gmail.com' THEN '56961407453'
    WHEN 'infodosantosfc@gmail.com' THEN '573173905562'
    ELSE buyer_phone END
WHERE buyer_email IN ('cadete711@gmail.com', 'sugey_1279@hotmail.com', 'diegoupel35@gmail.com', 'lauranicoll.chacon@gmail.com', 'ajolon@gmail.com', 'carvajalm295@gmail.com', 'josemiguelfbz337@gmail.com', 'jonathan.d.12@hotmail.com', 'alvarez.pao@gmail.com', 'mporritasg@gmail.com', 'pardok94@gmail.com', 'esperanza@ehopeusa.com', 'jeniferisazaluna@gmail.com', 'dianaarizam87@gmail.com', 'karyviqueira@gmail.com', 'susanabarahona21@gmail.com', 'koke.macias@gmail.com', 'sandraurqui1@gmail.com', 'beraguirre@gmail.com', 'activalamujer@hotmail.com', 'jenniferquimbayo92@gmail.com', 'cordovaalejandra29@gmail.com', 'misabelvillar@hotmail.com', 'gabriel.cifuentes.m@gmail.com', 'academy777lhm@gmail.com', 'marielapollastrini18@gmail.com', 'solucionmaldonado67@gmail.com', 'kathy_sofi95@hotmail.com', 'boriscometta27@gmail.com', 'opticanewtonsa@gmail.com', 'lauryrua95@gmail.com', 'alberto_acosta1@hotmail.com', 'nataliahl2010@hotmail.com', 'topteninmobiliaria55@gmail.com', 'pablocelis11@gmail.com', 'karendiazm@hotmail.com', 'hoyosjeimy96@gmail.com', 'yeshuarodriguezsilva@gmail.com', 'xp.yar4@gmail.com', 'adoariza05@gmail.com', 'jorgefilmmaking@gmail.com', 'caroll91rodriguez@gmail.com', 'gercysimet8@gmail.com', 'dimaleva_58@hotmail.com', 'camiloandresp19@hotmail.com', 'banuelosmd@gmail.com', 'tarangoplay@gmail.com', 'andreaceh16@gmail.com', 'alejo20j@gmail.com', 'vivianasamaniego1283@gmail.com', 'rbnguillermo@gmail.com', 'santyadss@gmail.com', 'biscuerobayo@hotmail.com', 'andrea@andreaodle.com', 'acuerdosfinancierosldc@gmail.com', 'steffy.veliz23@gmail.com', 'coordinacioneventosvictoria@gmail.com', 'jefferson.marben10@gmail.com', 'kte-navarro@hotmail.com', 'paulitha3110@gmail.com', 'angelacusco2019@gmail.com', 'gromit4800@gmail.com', 'hmolanopatino@gmail.com', 'armandochazari@gmail.com', 'brepaca725@gmail.com', 'jenny.povedar@gmail.com', 'ceojairoavalos@gmail.com', 'lozano_702@hotmail.com', 'adricaballero10@hotmail.com', 'sebasrojasm@gmail.com', 'nicolshopiavanegasarenas@gmail.com', 'sindyanez05@gmail.com', 'lore.leon2412@gmail.com', 'info@samuelfranco.com', 'gustavoguerraventas@gmail.com', 'opt.a_armendariz@outlook.com', 'asanchezp1974@gmail.com', 'concejalnicolas@gmail.com', 'modebonilla@cococreativo.com.mx', 'anagaviriar05@gmail.com', 'm.jair2819@gmail.com', 'sxmauroxe@gmail.com', 'jart85@gmail.com', 'jmendezcalle@yahoo.com', 'gerencia@atiempo.com.ec', 'bluagencia2021@gmail.com', 'glendafernandez777@icloud.com', 'cpn.hugosolalinde@gmail.com', 'gomezmilena781@gmail.com', 'felipedr161@hotmail.com', 'jhonyquevedo@gmail.com', 'alojah83@gmail.com', 'marceco1975@hotmail.com', 'hernandezmartinezalexis@gmail.com', 'caprietos@yahoo.com', 'lizeth27642@hotmail.com', 'sebastianrc15.2@gmail.com', 'hortensia@encasapanama.com', 'lewistrp@gmail.com', 'diana19484@hotmail.com', 'osiris1323@yahoo.com', 'denegociosco@gmail.com', 'aleparraduque@gmail.com', 'paulaguarnido15@gmail.com', 'juanpablo.g@solucioneseducativastc.com', 'henryquilind58@gmail.com', 'johan078colombia@hotmail.com', 'jcamiloaga@gmail.com', 'dianalucia2021@yahoo.com', 'jmalvarez@catalizando.com', 'lauravanessa.marquezc@gmail.com', 'rlgladys258@gmail.com', 'drgarcia.emprende@gmail.com', 'tefagomez.art@gmail.com', 'andres7max@gmail.com', 'ger061136@gmail.com', 'tomassisa72@gmail.com', 'caprichosspa2019@gmail.com', 'jorgerodriguezinvestment@gmail.com', 'josegplazas@gmail.com', 'dropshippingecommercemastery@gmail.com', 'morenoricardo848@gmail.com', 'oscarmau1@outlook.com', 'marthaostios@hotmail.com', 'impulsa_markting1.0@gmail.com', 'saavedra.ro75@gmail.com', 'kevinfpa1406@gmail.com', 'sanchez_laura.h@hotmail.com', 'heiber025@gmail.com', 'eventosclubdecampolipangue@gmail.com', 'euvivolavida@hotmail.com', 'lizbethdvand@gmail.com', 'yurani2102jeronimo@gmail.com', 'duqueandrea079@gmail.com', 'fabian.gacosta@gmail.com', 'danimosidj@gmail.com', 'andres580357@gmail.com', 'celecomunica@gmail.com', 'yuryjimenez@gmail.com', 'behappynailscl@gmail.com', 'marketingllado@gmail.com', 'joelmejia708@gmail.com', 'kristhina39@hotmail.com', 'santicada@gmail.com', 'rauljtorres18@gmail.com', 'elpandaaoficial@gmail.com', 'jackfalvarado@gmail.com', 'daniela.ortizmedia@gmail.com', 'alejandroartis495@gmail.com', 'icristina_perezv@hotmail.com', 'kmbmarketing01@gmail.com', 'milezagi@gmail.com', 'karolinaochoa.ag@gmail.com', 'jdanielrl@gmail.com', 'lizmanriqueugc@gmail.com', 'sandramilenaescobar@hotmail.com', 'luferpsicologadigital@gmail.com', 'fitnessjeikmart@gmail.com', 'estheladuchesalazar@gmail.com', 'coloreartumente@gmail.com', 'unasgotasmagicas@gmail.com', 'andresmape1991@gmail.com', 'ovalle.vanessa@gmail.com', 'clauloc@outlook.com', 'gokuygohan9999@gmail.com', 'memero86@gmail.com', 'luis.feernandog@gmail.com', 'angelikbp45@gmail.com', 'claudiaaserna@hotmail.com', 'contactomagentaxv@gmail.com', 'mkarmengl@hotmail.com', 'cindysilvajesus8@gmail.com', 'carlosbuitrago1992@hotmail.com', 'kaorimurasaki205@gmail.com', 'edwar31mejia@gmail.com', 'lejarazu86@gmail.com', 'maymont6212@gmail.com', 'gifagomu1986@gmail.com', 'johamarketing@gmail.com', 'cohencaceres@gmail.com', 'lanishellw@hotmail.com', 'narusanarusewawa@gmail.com', 'marisolenriquez0101@gmail.com', 'carlosballesteros777@hotmail.com', 'cris_david97@hotmail.com', 'creativo@erickraw.page', 'dianajarangoa@gmail.com', 'pilar.sanchez1919@gmail.com', 'alfredodelcastillo511@gmail.com', 'rodrigoospino@hotmail.com', 'tatianavargas026@gmail.com', 'mercadeoglobalvitality@gmail.com', 'vibesbgta@gmail.com', 'maikolquintero20@gmail.com', 'toutsurlemarketingdereseau@gmail.com', 'lauravierab@gmail.com', 'erickarnulfo2@gmail.com', 'lisandrapi1986@gmail.com', 'ovejares@gmail.com', 'infodosantosfc@gmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'edgar.garcia.rsvp@gmail.com' THEN '529983072394'
    WHEN 'rlopezp.ambassador@gmail.com' THEN '51944162109'
    WHEN 'maitevega758@gmail.com' THEN '112406394115'
    WHEN 'palomacm@me.com' THEN '525529001657'
    WHEN 'yeimybm@hotmail.com' THEN '573116262560'
    WHEN 'glenda.carranza@gmail.com' THEN '525516457665'
    WHEN 'romor.oficial@gmail.com' THEN '56975845508'
    WHEN 'jennyvivianamartinez1987@gmail.com' THEN '56949721052'
    WHEN 'aguilerabrito.beatriz@gmail.com' THEN '56994252429'
    WHEN 'alexipatino78@gmail.com' THEN '573023716959'
    WHEN 'lozpatricia@gmail.com' THEN '573104041994'
    WHEN 'bitacoraroundtrip@gmail.com' THEN '18328357169'
    WHEN 'manuelavilla06@hotmail.com' THEN '573207284706'
    WHEN 'delvinquispem@gmail.com' THEN '51978391622'
    WHEN 'eligilram@gmail.com' THEN '573004869467'
    WHEN 'lic.victorjavier@hotmail.com' THEN '527226009153'
    WHEN 'rocio.astocaza@gmail.com' THEN '51962332779'
    WHEN 'saligore@hotmail.com' THEN '16892697357'
    WHEN 'rickdelarosa@outlook.com' THEN '525525617996'
    WHEN 'rivera172050@gmail.com' THEN '51981347056'
    WHEN 'leidyquicenoc@gmail.com' THEN '573178099599'
    WHEN 'manuelyongb@hotmail.com' THEN '524421494414'
    WHEN 'depositosonline24@gmail.com' THEN '13237936257'
    WHEN 'pariasrealtor@gmail.com' THEN '573108136313'
    WHEN 'stellakin69@gmail.com' THEN '573054606549'
    WHEN 'charlesbarrera@hotmail.es' THEN '573013387080'
    WHEN 'edwinrodriguezm777@gmail.com' THEN '573153712295'
    WHEN 'marlloryvd94@outlook.com' THEN '593962576922'
    WHEN 'bellocabreran@gmail.com' THEN '17868260811'
    WHEN 'julianlandazabal01@gmail.com' THEN '573208335325'
    WHEN 'diazconsultorescontables@gmail.com' THEN '593999921259'
    WHEN 'daisymacmontoyav@gmail.com' THEN '573127395632'
    WHEN 'leowave97@hotmail.com' THEN '543884137484'
    WHEN 'castrorubiela1982@gmail.com' THEN '573202633045'
    WHEN 'yeapare@gmail.com' THEN '573104121454'
    WHEN 'silviagonzalez.mkt@gmail.com' THEN '528332884860'
    WHEN 'rosendobig2016@gmail.com' THEN '573024715674'
    WHEN 'engyyes@hotmail.com' THEN '573203200298'
    WHEN 'javibillions@gmail.com' THEN '12393834419'
    WHEN 'nataorma.30@gmail.com' THEN '573135943411'
    WHEN 'dmarcemont@hotmail.com' THEN '573144341359'
    WHEN 'daniycn13@gmail.com' THEN '573246640429'
    WHEN 'alexpuentess10@gmail.com' THEN '56974807532'
    WHEN 'albeiroosorio182@gmail.com' THEN '573177678684'
    WHEN 'luismotacreativo@gmail.com' THEN '15154212187'
    WHEN 'jesika.giraldo@gmail.com' THEN '573233725511'
    WHEN 'eriyul21@hotmail.com' THEN '573158975250'
    WHEN 'yimarire_03@hotmail.com' THEN '573502672233'
    WHEN 'estebanbedoya07@gmail.com' THEN '573176546140'
    WHEN 'mariacamiladuque626@hotmail.com' THEN '573185275662'
    WHEN 'glenisyc1985@gmail.com' THEN '573175442828'
    WHEN 'gustavoadolfof@yahoo.com' THEN '573197066746'
    WHEN 'moni.mateus@hotmail.com' THEN '573112868672'
    WHEN 'arlynxm3@gmail.com' THEN '19096315768'
    WHEN 'varolas@hotmail.com' THEN '523111081919'
    WHEN 'elianats101995@hotmail.com' THEN '573214656862'
    WHEN 'andrepadilla_dg@hotmail.es' THEN '573045603077'
    WHEN 'digitizeteam@gmail.com' THEN '18644511387'
    WHEN 'jimmyferlissi@gmail.com' THEN '56963437657'
    WHEN 'chenegrocr@gmail.com' THEN '50670248602'
    WHEN 'letsanva@yahoo.com.mx' THEN '524433364723'
    WHEN 'voittogroup.az@gmail.com' THEN '114805275973'
    WHEN 'josmanleon2023@gmail.com' THEN '14259700488'
    WHEN 'karolinatrochez@gmail.com' THEN '18045733224'
    WHEN 'andreapinzonq@gmail.com' THEN '573107812320'
    WHEN 'l.ortizcarvacho@gmail.com' THEN '56940580380'
    WHEN 'edgar5_14@hotmail.com' THEN '51930917645'
    WHEN 'dannysase123@gmail.com' THEN '51973441385'
    WHEN 'soyemilyarvi@gmail.com' THEN '573114015232'
    WHEN 'kurtgajardo@gmail.com' THEN '56934058448'
    WHEN 'diegoriascos16@gmail.com' THEN '573116047812'
    WHEN 'creamosvalor1@gmail.com' THEN '573185747364'
    WHEN 'hidelacruz@yahoo.com' THEN '17862660444'
    WHEN 'imperiostours@gmail.com' THEN '573007525024'
    WHEN 'geekjfredo@gmail.com' THEN '573128819198'
    WHEN 'andreavelascofuxion@gmail.com' THEN '573216638373'
    WHEN 'soylauhuerfano@gmail.com' THEN '573213032147'
    WHEN 'mcsaleos@gmail.com' THEN '19094529024'
    WHEN 'geral99jll@gmail.com' THEN '51926703196'
    WHEN 'gonzalez_o_alejandro@hotmail.com' THEN '573137593849'
    WHEN 'lauralorena99v@gmail.com' THEN '573118943869'
    WHEN 'isabelpesantez.a@gmail.com' THEN '5930987255282'
    WHEN 'sosa-roa@hotmail.com' THEN '573188711588'
    WHEN 'danipiercing.22@gmail.com' THEN '573005358204'
    WHEN 'elsybarrero@gmail.com' THEN '573178833320'
    WHEN 'ginistoro1@gmail.com' THEN '573114237246'
    WHEN 'diego.palacio10@hotmail.com' THEN '573103970289'
    WHEN 'luispo14@hotmail.com' THEN '573206648136'
    WHEN 'paola3qui@icloud.com' THEN '17328674779'
    WHEN 'manu.rojas.rios@gmail.com' THEN '573122571393'
    WHEN 'leidyjohana1003@hotmail.com' THEN '573142209670'
    WHEN 'camilo-sanchez@hotmail.com' THEN '573164782182'
    WHEN 'lexmarketer2025@gmail.com' THEN '527227968678'
    WHEN 'malun1694@hotmail.com' THEN '573507538567'
    WHEN 'davidduquecastillo@gmail.com' THEN '573116123952'
    WHEN 'jhonalexander2815@gmail.com' THEN '573167487036'
    WHEN 'alfonsoorozcoo@hotmail.com' THEN '529983853921'
    WHEN 'joyasconexion.japamala@gmail.com' THEN '573193115044'
    WHEN 'jpbravoa.jpb@gmail.com' THEN '573145850785'
    WHEN 'catalinach05@gmail.com' THEN '573128931738'
    WHEN 'gallegosbruno96@gmail.com' THEN '5403513922230'
    WHEN 'ramirez.salo08@gmail.com' THEN '523411267703'
    WHEN 'maryvit2601@gmail.com' THEN '524426070703'
    WHEN 'madretierranatural@hotmail.com' THEN '5713167598266'
    WHEN 'rosabelrinconhernandez@gmail.com' THEN '573172581454'
    WHEN 'soygusmasterdigital@gmail.com' THEN '573123266967'
    WHEN 'avanta.col@gmail.com' THEN '573126029038'
    WHEN 'celso@clickdesignmedia.com' THEN '114432213397'
    WHEN 'vasquezgomezjenifer@gmail.com' THEN '573194626984'
    WHEN 'soporteyeimerrestrepo@gmail.com' THEN '573009536709'
    WHEN 'dayro.bohorquez@gmail.com' THEN '573145907636'
    WHEN 'jmbecerrar@icloud.com' THEN '573243687395'
    WHEN 'danielapsepulveda@gmail.com' THEN '573106895845'
    WHEN 'infrarojoestudio@gmail.com' THEN '573233828493'
    WHEN 'durdely@gmail.com' THEN '573005770799'
    WHEN 'svascoca@gmail.com' THEN '573013925467'
    WHEN 'smosqueramazud@gmail.com' THEN '573184705945'
    WHEN 'prolims_eat1123@hotmail.com' THEN '5930998133567'
    WHEN 'valeriavalencia9635@gmail.com' THEN '573122342119'
    WHEN 'jhonathanjimenezg@gmail.com' THEN '573226545283'
    WHEN 'ricardocardonaafiliado@gmail.com' THEN '50258944241'
    WHEN 'pauendec@gmail.com' THEN '5930986934950'
    WHEN 'angelita1985caicedo@hotmail.com' THEN '573157804396'
    WHEN 'daymara.aroon.28@gmail.com' THEN '573057729653'
    WHEN 'carocboteroo@gmail.com' THEN '56963901813'
    WHEN 'carlospty7@gmail.com' THEN '50766181309'
    WHEN 'edilmadeb@hotmail.com' THEN '50763046899'
    WHEN 'jdelcastillo18@gmail.com' THEN '573154955007'
    WHEN 'trainer@paolapaico.com' THEN '51995120965'
    WHEN 'ngallegolondono@gmail.com' THEN '573175746544'
    WHEN 'sbaquero555@gmail.com' THEN '16465225724'
    WHEN 'alda.perez37@hotmail.com' THEN '51987088359'
    WHEN 'emprendo.mkt90@gmail.com' THEN '51912807883'
    WHEN 'brandonsocampo@gmail.com' THEN '573143542732'
    WHEN 'hans@robles.com.ec' THEN '593994915347'
    WHEN 'edgar7mauro@hotmail.com' THEN '51975351552'
    WHEN 'kleberhoy@outlook.com' THEN '593958992282'
    WHEN 'marianaherrera460@gmail.com' THEN '573197630186'
    WHEN 'diegopg816@gmail.com' THEN '573108648879'
    WHEN 'jhonyadelgadof@gmail.com' THEN '573147885840'
    WHEN 'rossinardzconsultoria@gmail.com' THEN '528114134197'
    WHEN 'luisamlopera@gmail.com' THEN '573113788432'
    WHEN 'juanyvillalbaendigital@gmail.com' THEN '5950992603841'
    WHEN 'tatyspretty@hotmail.com' THEN '5930999717879'
    WHEN 'ana.gomez@jeanscolombianos.com' THEN '573188270557'
    WHEN 'valstudiocreative@gmail.com' THEN '573014381707'
    WHEN 'samuelboca.111@gmail.com' THEN '573154153312'
    WHEN 'dianadelgadodigital@gmail.com' THEN '573174273795'
    WHEN 'raule0997@gmail.com' THEN '573217420378'
    WHEN 'enriquevillalobosr@gmail.com' THEN '523481025754'
    WHEN 'pablostefanodg@gmail.com' THEN '593989784440'
    WHEN 'madelenyy21@gmail.com' THEN '573015079827'
    WHEN 'diestros1@gmail.com' THEN '573152901017'
    WHEN 'linatamayo@remaxm.net' THEN '18293414827'
    WHEN 'esteban_jz@outlook.es' THEN '573146775197'
    WHEN 'gonzalezmlaura@hotmail.com' THEN '573217068699'
    WHEN 'alejandra.frost.a@gmail.com' THEN '56981363227'
    WHEN 'gustavosorio1020@gmail.com' THEN '573046618072'
    WHEN 'alexanderdomenech.b@gmail.com' THEN '573102144322'
    WHEN 'aizajar@gmail.com' THEN '17544223859'
    WHEN 'golgag@yahoo.com' THEN '573006125101'
    WHEN 'ceciliaorellana27@gmail.com' THEN '12018871744'
    WHEN 'garpchile@gmail.com' THEN '56948012145'
    WHEN 'jdjcoronado@yahoo.es' THEN '573107391587'
    WHEN 'sandrasantamariacoach@gmail.com' THEN '573154838176'
    WHEN 'jucamilo15@hotmail.com' THEN '115484680101'
    WHEN 'karla8383carrillo@yahoo.com' THEN '114155745343'
    WHEN 'marianelacardenasv@yahoo.es' THEN '573103096891'
    WHEN 'bibikjeldsen@gmail.com' THEN '19149201737'
    WHEN 'carloscamacho.doc@gmail.com' THEN '573153061993'
    WHEN 'john.loaiza.guerra@gmail.com' THEN '573052492697'
    WHEN 'lianariosh@gmail.com' THEN '573176667951'
    WHEN 'lusuarez.med@gmail.com' THEN '573202142620'
    WHEN 'yamilok-13@hotmail.com' THEN '573134482249'
    WHEN 'jaimeuriasmkt@gmail.com' THEN '526721234844'
    WHEN 'vanesa@mentalidadinquebrantable.com' THEN '541154871413'
    WHEN 'danielaom31.dom@gmail.com' THEN '573163709960'
    WHEN 'cesargarcia72012@hotmail.com' THEN '573041074633'
    WHEN 'geovanylondono1@hotmail.com' THEN '573173355650'
    WHEN 'vivienvacafashion@gmail.com' THEN '5930981174411'
    WHEN 'enrique.isarra@gmail.com' THEN '51992191219'
    WHEN 'crksoritor@gmail.com' THEN '51935101552'
    WHEN 'arqous.info@gmail.com' THEN '17868968246'
    WHEN 'michaelcruzhomes@gmail.com' THEN '14075307620'
    WHEN 'mitchelckimberlyn@gmail.com' THEN '118542369012'
    WHEN 'tlandetta@gmail.com' THEN '593991775229'
    WHEN 'norly.cabrera@riverdistrict14.com' THEN '17863005012'
    WHEN 'dentalclubcenter@gmail.com' THEN '527226165686'
    WHEN 'yosoymafe@gmail.com' THEN '573153174601'
    WHEN 'finanzasesumer@gmail.com' THEN '573174354962'
    WHEN 'carlosdiego8@yahoo.com.co' THEN '573117477926'
    WHEN 'joseangelsantosgaitan@gmail.com' THEN '526647584416'
    WHEN 'darias.sepulveda@gmail.com' THEN '573207410312'
    WHEN 'ncruz02@gmail.com' THEN '116026538100'
    WHEN 'henryalbertocr@gmail.com' THEN '573242197179'
    WHEN 'ljohanaosorio@gmail.com' THEN '18137862946'
    WHEN 'lina.de.do@gmail.com' THEN '522292070525'
    WHEN 'info@amhpartnersllc.com' THEN '118453812782'
    WHEN 'mariapaula@qhubocars.com' THEN '117867848933'
    WHEN 'claraliagutierrez@gmail.com' THEN '573218010677'
    ELSE buyer_phone END
WHERE buyer_email IN ('edgar.garcia.rsvp@gmail.com', 'rlopezp.ambassador@gmail.com', 'maitevega758@gmail.com', 'palomacm@me.com', 'yeimybm@hotmail.com', 'glenda.carranza@gmail.com', 'romor.oficial@gmail.com', 'jennyvivianamartinez1987@gmail.com', 'aguilerabrito.beatriz@gmail.com', 'alexipatino78@gmail.com', 'lozpatricia@gmail.com', 'bitacoraroundtrip@gmail.com', 'manuelavilla06@hotmail.com', 'delvinquispem@gmail.com', 'eligilram@gmail.com', 'lic.victorjavier@hotmail.com', 'rocio.astocaza@gmail.com', 'saligore@hotmail.com', 'rickdelarosa@outlook.com', 'rivera172050@gmail.com', 'leidyquicenoc@gmail.com', 'manuelyongb@hotmail.com', 'depositosonline24@gmail.com', 'pariasrealtor@gmail.com', 'stellakin69@gmail.com', 'charlesbarrera@hotmail.es', 'edwinrodriguezm777@gmail.com', 'marlloryvd94@outlook.com', 'bellocabreran@gmail.com', 'julianlandazabal01@gmail.com', 'diazconsultorescontables@gmail.com', 'daisymacmontoyav@gmail.com', 'leowave97@hotmail.com', 'castrorubiela1982@gmail.com', 'yeapare@gmail.com', 'silviagonzalez.mkt@gmail.com', 'rosendobig2016@gmail.com', 'engyyes@hotmail.com', 'javibillions@gmail.com', 'nataorma.30@gmail.com', 'dmarcemont@hotmail.com', 'daniycn13@gmail.com', 'alexpuentess10@gmail.com', 'albeiroosorio182@gmail.com', 'luismotacreativo@gmail.com', 'jesika.giraldo@gmail.com', 'eriyul21@hotmail.com', 'yimarire_03@hotmail.com', 'estebanbedoya07@gmail.com', 'mariacamiladuque626@hotmail.com', 'glenisyc1985@gmail.com', 'gustavoadolfof@yahoo.com', 'moni.mateus@hotmail.com', 'arlynxm3@gmail.com', 'varolas@hotmail.com', 'elianats101995@hotmail.com', 'andrepadilla_dg@hotmail.es', 'digitizeteam@gmail.com', 'jimmyferlissi@gmail.com', 'chenegrocr@gmail.com', 'letsanva@yahoo.com.mx', 'voittogroup.az@gmail.com', 'josmanleon2023@gmail.com', 'karolinatrochez@gmail.com', 'andreapinzonq@gmail.com', 'l.ortizcarvacho@gmail.com', 'edgar5_14@hotmail.com', 'dannysase123@gmail.com', 'soyemilyarvi@gmail.com', 'kurtgajardo@gmail.com', 'diegoriascos16@gmail.com', 'creamosvalor1@gmail.com', 'hidelacruz@yahoo.com', 'imperiostours@gmail.com', 'geekjfredo@gmail.com', 'andreavelascofuxion@gmail.com', 'soylauhuerfano@gmail.com', 'mcsaleos@gmail.com', 'geral99jll@gmail.com', 'gonzalez_o_alejandro@hotmail.com', 'lauralorena99v@gmail.com', 'isabelpesantez.a@gmail.com', 'sosa-roa@hotmail.com', 'danipiercing.22@gmail.com', 'elsybarrero@gmail.com', 'ginistoro1@gmail.com', 'diego.palacio10@hotmail.com', 'luispo14@hotmail.com', 'paola3qui@icloud.com', 'manu.rojas.rios@gmail.com', 'leidyjohana1003@hotmail.com', 'camilo-sanchez@hotmail.com', 'lexmarketer2025@gmail.com', 'malun1694@hotmail.com', 'davidduquecastillo@gmail.com', 'jhonalexander2815@gmail.com', 'alfonsoorozcoo@hotmail.com', 'joyasconexion.japamala@gmail.com', 'jpbravoa.jpb@gmail.com', 'catalinach05@gmail.com', 'gallegosbruno96@gmail.com', 'ramirez.salo08@gmail.com', 'maryvit2601@gmail.com', 'madretierranatural@hotmail.com', 'rosabelrinconhernandez@gmail.com', 'soygusmasterdigital@gmail.com', 'avanta.col@gmail.com', 'celso@clickdesignmedia.com', 'vasquezgomezjenifer@gmail.com', 'soporteyeimerrestrepo@gmail.com', 'dayro.bohorquez@gmail.com', 'jmbecerrar@icloud.com', 'danielapsepulveda@gmail.com', 'infrarojoestudio@gmail.com', 'durdely@gmail.com', 'svascoca@gmail.com', 'smosqueramazud@gmail.com', 'prolims_eat1123@hotmail.com', 'valeriavalencia9635@gmail.com', 'jhonathanjimenezg@gmail.com', 'ricardocardonaafiliado@gmail.com', 'pauendec@gmail.com', 'angelita1985caicedo@hotmail.com', 'daymara.aroon.28@gmail.com', 'carocboteroo@gmail.com', 'carlospty7@gmail.com', 'edilmadeb@hotmail.com', 'jdelcastillo18@gmail.com', 'trainer@paolapaico.com', 'ngallegolondono@gmail.com', 'sbaquero555@gmail.com', 'alda.perez37@hotmail.com', 'emprendo.mkt90@gmail.com', 'brandonsocampo@gmail.com', 'hans@robles.com.ec', 'edgar7mauro@hotmail.com', 'kleberhoy@outlook.com', 'marianaherrera460@gmail.com', 'diegopg816@gmail.com', 'jhonyadelgadof@gmail.com', 'rossinardzconsultoria@gmail.com', 'luisamlopera@gmail.com', 'juanyvillalbaendigital@gmail.com', 'tatyspretty@hotmail.com', 'ana.gomez@jeanscolombianos.com', 'valstudiocreative@gmail.com', 'samuelboca.111@gmail.com', 'dianadelgadodigital@gmail.com', 'raule0997@gmail.com', 'enriquevillalobosr@gmail.com', 'pablostefanodg@gmail.com', 'madelenyy21@gmail.com', 'diestros1@gmail.com', 'linatamayo@remaxm.net', 'esteban_jz@outlook.es', 'gonzalezmlaura@hotmail.com', 'alejandra.frost.a@gmail.com', 'gustavosorio1020@gmail.com', 'alexanderdomenech.b@gmail.com', 'aizajar@gmail.com', 'golgag@yahoo.com', 'ceciliaorellana27@gmail.com', 'garpchile@gmail.com', 'jdjcoronado@yahoo.es', 'sandrasantamariacoach@gmail.com', 'jucamilo15@hotmail.com', 'karla8383carrillo@yahoo.com', 'marianelacardenasv@yahoo.es', 'bibikjeldsen@gmail.com', 'carloscamacho.doc@gmail.com', 'john.loaiza.guerra@gmail.com', 'lianariosh@gmail.com', 'lusuarez.med@gmail.com', 'yamilok-13@hotmail.com', 'jaimeuriasmkt@gmail.com', 'vanesa@mentalidadinquebrantable.com', 'danielaom31.dom@gmail.com', 'cesargarcia72012@hotmail.com', 'geovanylondono1@hotmail.com', 'vivienvacafashion@gmail.com', 'enrique.isarra@gmail.com', 'crksoritor@gmail.com', 'arqous.info@gmail.com', 'michaelcruzhomes@gmail.com', 'mitchelckimberlyn@gmail.com', 'tlandetta@gmail.com', 'norly.cabrera@riverdistrict14.com', 'dentalclubcenter@gmail.com', 'yosoymafe@gmail.com', 'finanzasesumer@gmail.com', 'carlosdiego8@yahoo.com.co', 'joseangelsantosgaitan@gmail.com', 'darias.sepulveda@gmail.com', 'ncruz02@gmail.com', 'henryalbertocr@gmail.com', 'ljohanaosorio@gmail.com', 'lina.de.do@gmail.com', 'info@amhpartnersllc.com', 'mariapaula@qhubocars.com', 'claraliagutierrez@gmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'estevancartagena@gmail.com' THEN '573172422348'
    WHEN 'villanica@gmail.com' THEN '573022064105'
    WHEN 'liizlacruz@gmail.com' THEN '573108084652'
    WHEN 'bexterfilms1518@gmail.com' THEN '593979127607'
    WHEN 'rebecademonzon@yahoo.com.mx' THEN '50237580111'
    WHEN 'klaudyaportes@gmail.com' THEN '114709096892'
    WHEN 'zullihoyod@gmail.com' THEN '573150525897'
    WHEN 'molinafabianarq@gmail.com' THEN '19546828165'
    WHEN 'hallertirado@gmail.com' THEN '528112865979'
    WHEN 'billonariolatino21k@gmail.com' THEN '51931193061'
    WHEN 'alejandrolorenzl@hotmail.com' THEN '5491151214429'
    WHEN 'adnfitnessjujuy@gmail.com' THEN '543884971187'
    WHEN 'dianamarcelarias@gmail.com' THEN '18167267192'
    WHEN 'integralbodybeauty@gmail.com' THEN '17086858741'
    WHEN 'danycaceresagnello@gmail.com' THEN '56982490210'
    WHEN 'yenit_27@hotmail.com' THEN '50767472941'
    WHEN 'ravellanedam@gmail.com' THEN '51932935809'
    WHEN 'garciavasquezgabriel@gmail.com' THEN '573112233887'
    WHEN 'natalia03625@gmail.com' THEN '573177687420'
    WHEN 'cristiangzesc@gmail.com' THEN '18315370105'
    WHEN 'acgamboan@gmail.com' THEN '529982478663'
    WHEN 'colombianaautosales@gmail.com' THEN '14088029488'
    WHEN 'sicaagustin2000@gmail.com' THEN '542915758527'
    WHEN 'isabelsarca@gmail.com' THEN '573015625504'
    WHEN 'juanybric@msn.com' THEN '14074704741'
    WHEN 'melanievela43@gmail.com' THEN '50765174549'
    WHEN 'nataliamorenocalle@gmail.com' THEN '573103218394'
    WHEN 'julian.munozcruz@gmail.com' THEN '573183889485'
    WHEN 'javier.vasquezpalacios@hotmail.com' THEN '51981518535'
    WHEN 'lidumonasterio11@gmail.com' THEN '56945090711'
    WHEN 'agenciainmobiliariacancun@gmail.com' THEN '529988410165'
    WHEN 'fredy.gamarra.z@gmail.com' THEN '51956858541'
    WHEN 'aponteyaz201701@gmail.com' THEN '573007946596'
    WHEN 'sharikdnanda456@gmail.com' THEN '573215530423'
    WHEN 'ivonnealfonso28@gmail.com' THEN '573106095237'
    WHEN 'cajitamelosa@gmail.com' THEN '573053199030'
    WHEN 'lesanabriaochoa@gmail.com' THEN '573005390196'
    WHEN 'fabiansuperseya@gmail.com' THEN '573147882175'
    WHEN 'alexander.koteskys@gmail.com' THEN '56992993991'
    WHEN 'jom7215jom@gmail.com' THEN '51947487700'
    WHEN 'karenarodriguezg@gmail.com' THEN '112109145241'
    WHEN 'alexafreitez27@gmail.com' THEN '573013415651'
    WHEN 'florencia@inuitlab.com' THEN '541155746104'
    WHEN 'jose.viropa@gmail.com' THEN '13322837607'
    WHEN 'rayquipa@hotmail.com' THEN '51997508018'
    WHEN 'aryamfrigia@gmail.com' THEN '529983389040'
    WHEN 'mariaalexandragk@gmail.com' THEN '19546550399'
    WHEN 'nellyfloresegocheaga@gmail.com' THEN '51957357657'
    WHEN 'majopillo09@gmail.com' THEN '573246719337'
    WHEN 'redondo.paola@gmail.com' THEN '573114348345'
    WHEN 'aylin.alfaror@gmail.com' THEN '525610163221'
    WHEN 'denisseortiz35@gmail.com' THEN '19365486090'
    WHEN 'imjoyasplata@gmail.com' THEN '543644370217'
    WHEN 'paosinrumbo@gmail.com' THEN '573209469695'
    WHEN 'lourdesvrealtor@gmail.com' THEN '51991894043'
    WHEN 'wendybiflo@hotmail.com' THEN '119735365940'
    WHEN 'lu2montene@gmail.com' THEN '593993493312'
    WHEN 'edgarfaviani@gmail.com' THEN '50761225667'
    WHEN 'mariaelcycardozomartinez@gmail.com' THEN '573209138604'
    WHEN 'natalycreativa@hotmail.com' THEN '573105030165'
    WHEN 'carfel42@hotmail.com' THEN '5930958867583'
    WHEN 'angie.silva.9807@gmail.com' THEN '573123443074'
    WHEN 'mailithbustamante@gmail.com' THEN '573216176734'
    WHEN 'saratuxtra@gmail.com' THEN '18504057183'
    WHEN 'erita28_9@hotmail.com' THEN '573003527777'
    WHEN 'vivi.galindo83@outlook.com' THEN '573118814313'
    WHEN 'slpconstruction81@gmail.com' THEN '12818545647'
    WHEN 'veronicacuartassuarez@gmail.com' THEN '573225569806'
    WHEN 'joanna_amaral@live.com' THEN '541160950329'
    WHEN 'khatebolivarugc@gmail.com' THEN '573194154148'
    WHEN 'angie_0231@hotmail.com' THEN '17865387662'
    WHEN 'claudiadelahoz@hotmail.com' THEN '5491150575606'
    WHEN 'jimematacin@gmail.com' THEN '543414471371'
    WHEN 'paoaristizabal1@hotmail.com' THEN '573013451881'
    WHEN 'mcamilams2022@gmail.com' THEN '573147010438'
    WHEN 'rosarioochoa1102@gmail.com' THEN '573022346431'
    WHEN 'dperfectos@hotmail.com' THEN '16192791848'
    WHEN 'gilberto@gobemax.com' THEN '14805803590'
    WHEN 'c.gerardomontalvo@gmail.com' THEN '525576605992'
    WHEN 'spalzate@gmail.com' THEN '573108307034'
    WHEN 'gsefair@gmail.com' THEN '573226855866'
    WHEN 'crew@clandestinostudio.com' THEN '524776595449'
    WHEN 'di.chiriboga@gmail.com' THEN '593987289953'
    WHEN 'mauricioorjuela18@gmail.com' THEN '16146497069'
    WHEN 'morios.oficial@gmail.com' THEN '573214092936'
    WHEN 'fandosvictoria@gmail.com' THEN '541164102003'
    WHEN '3amultiservicesllc@gmail.com' THEN '118623889534'
    WHEN 'formacionfuturoglobal@gmail.com' THEN '112016475382'
    WHEN 'johan.fuen@gmail.com' THEN '573007869035'
    WHEN 'bronsillon90@hotmail.com' THEN '5930983023711'
    WHEN 'graphic.halland@gmail.com' THEN '56991224499'
    WHEN 'bernallcarloss21@gmail.com' THEN '527714200169'
    WHEN 'nydia_beltran@yahoo.com.mx' THEN '525554199234'
    WHEN 'mariaaquije35@gmail.com' THEN '51959555698'
    WHEN 'pau.cbe2530@gmail.com' THEN '51970360163'
    WHEN 'luigi.alcalde@gmail.com' THEN '51940428043'
    WHEN 'carlosjosuemz8@gmail.com' THEN '526145348986'
    WHEN 'karennataliaflorez457@gmail.com' THEN '573124650297'
    WHEN 'ramvaleria61@gmail.com' THEN '525580996901'
    WHEN 'aldo@aldocivico.com' THEN '16464920372'
    WHEN 'janissantaella@yahoo.com' THEN '18097297600'
    WHEN 'jonavypiedrahita@gmail.com' THEN '573216610543'
    WHEN 'elianapg9294@gmail.com' THEN '14438810280'
    WHEN 'jorgeramirezdocenciadeportiva@gmail.com' THEN '525518385601'
    WHEN 'realty.golden@gmail.com' THEN '573175115296'
    WHEN 'rodriguez22_ashlee@hotmail.com' THEN '524612350988'
    WHEN 'fabiobayonarios@gmail.com' THEN '573102859646'
    WHEN 'monimerchan@gmail.com' THEN '573154217882'
    WHEN 'julirolspper@gmail.com' THEN '573118369652'
    WHEN 'jonathan.mrh@outlook.com' THEN '529511302789'
    WHEN 'dpolania92@gmail.com' THEN '573206194519'
    WHEN 'atomatizaciones.ctrl.v@gmail.com' THEN '573058264115'
    WHEN 'mateolambisgomez9@gmail.com' THEN '573104678471'
    WHEN 'julianarias502@gmail.com' THEN '541127842934'
    WHEN 'paul_pb15@hotmail.com' THEN '113474015905'
    WHEN 'latindjsoc@gmail.com' THEN '17146316598'
    WHEN 'joseok86@gmail.com' THEN '116562412491'
    WHEN 'dorothy.gonzalez@figoservices.com' THEN '50766178794'
    WHEN 'rgonzalez@asesoriasglobales.cl' THEN '56963008502'
    WHEN 'soyricardocastillo222@gmail.com' THEN '15715521954'
    WHEN 'barradd@gmail.com' THEN '525518466961'
    WHEN 'jans1609@gmail.com' THEN '524611249522'
    WHEN 'topetelm@gmail.com' THEN '524423764202'
    WHEN 'lcatalina.valencia@gmail.com' THEN '573217770986'
    WHEN 'shantajo@hotmail.com' THEN '573008513675'
    WHEN 'mishellecjg@hotmail.com' THEN '528712779377'
    WHEN 'laura.bunge@icloud.com' THEN '541141461135'
    WHEN 'jhonatan1993aaguilar@gmail.com' THEN '573213749819'
    WHEN 'j4tzu3@gmail.com' THEN '541135769434'
    WHEN 'manu.valladares90@gmail.com' THEN '56950006278'
    WHEN 'maryohaa277@gmail.com' THEN '573042919149'
    WHEN 'jorgelinadc@gmail.com' THEN '5401125296009'
    WHEN 'argesestudios@gmail.com' THEN '573104000858'
    WHEN 'rosierod24@gmail.com' THEN '115129981223'
    WHEN 'katyvilleg@gmail.com' THEN '117863789731'
    WHEN 'oriettmarquez@hotmail.com' THEN '528182804874'
    WHEN 'geinermedinalopez9@gmail.com' THEN '51963821055'
    WHEN 'jbetts80@gmail.com' THEN '573184227932'
    WHEN 'mariajosezamorano92@gmail.com' THEN '573117531076'
    WHEN 'equiposoporteeyj@gmail.com' THEN '5930992156293'
    WHEN 'mohaalm57@gmail.com' THEN '34632659293'
    WHEN 'yvanmr777@gmail.com' THEN '17864884527'
    WHEN 'mario.szp27@gmail.com' THEN '526643452438'
    WHEN 'alexasantysteban@hotmail.com' THEN '593968161315'
    WHEN 'hbegazo@grupoissa.org' THEN '51995097523'
    WHEN 'noheliaestrad@msn.com' THEN '5930994280626'
    WHEN 'yoli_gh@yahoo.com' THEN '573205165860'
    WHEN 'academiahispanadepnl@gmail.com' THEN '573002300784'
    WHEN 'johnyposada@hotmail.com' THEN '573213654476'
    WHEN 'paolamembrillo@yahoo.com.mx' THEN '523336766024'
    WHEN 'karlalar@gmail.com' THEN '525529100162'
    WHEN 'nenis.posso@gmail.com' THEN '50766718205'
    WHEN 'niurka.jovanovich.luza@gmail.com' THEN '51955041944'
    WHEN 'garzon.gustavoa@gmail.com' THEN '19045202332'
    WHEN 'kenyadiaz@gmail.com' THEN '525534463349'
    WHEN 'canilla007@gmail.com' THEN '525518838788'
    WHEN 'viwe.org@gmail.com' THEN '523310216000'
    WHEN 'kerimparra@gmail.com' THEN '573016902572'
    WHEN 'miguelmlemus@gmail.com' THEN '573104229602'
    WHEN 'luisfelipe1213@gmail.com' THEN '573017353297'
    WHEN 'luzgmay@gmail.com' THEN '573213024964'
    WHEN 'maria.olavarri27@gmail.com' THEN '529213034593'
    WHEN 'tatianaserna1209@gmail.com' THEN '573105390886'
    WHEN 'danielpinillarojas@gmail.com' THEN '573143581033'
    WHEN 'monarchoficial@gmail.com' THEN '573022924339'
    WHEN 'yurgennyrosario@gmail.com' THEN '15162691986'
    WHEN 'roberttolentopro@gmail.com' THEN '51971427144'
    WHEN 'marcela3443.34@gmail.com' THEN '573002825440'
    WHEN 'chiko228@gmail.com' THEN '573002963838'
    WHEN 'lourdes14772@gmail.com' THEN '15518040714'
    WHEN 'bgsaplicaciones@gmail.com' THEN '573153186241'
    WHEN 'yisethbeltran2006@gmail.com' THEN '573113363502'
    WHEN 'magima89@gmail.com' THEN '573177346317'
    WHEN 'dratatianaceballos@gmail.com' THEN '573208064392'
    WHEN 'gadn88@gmail.com' THEN '573234253036'
    WHEN 'vcamargod2016@gmail.com' THEN '573014849722'
    WHEN 'oscarjavierpizza@gmail.com' THEN '573192209773'
    WHEN 'yeraldintriana09@gmail.com' THEN '573214227683'
    WHEN 'manuelaepedesign@gmail.com' THEN '573136875700'
    WHEN 'johanita.trusca@gmail.com' THEN '573106904141'
    WHEN 'evaromeror@yahoo.com' THEN '573178581791'
    WHEN 'hola@elalgo.co' THEN '573208335919'
    WHEN 'vivian.andrea0131@gmail.com' THEN '573147980314'
    WHEN 'tabaresarboleda@gmail.com' THEN '573006904212'
    WHEN 'pabrilda7314@icloud.com' THEN '573132046717'
    WHEN 'yeber32@gmail.com' THEN '573214099228'
    WHEN 'verokar2008@gmail.com' THEN '573138173409'
    WHEN 'maristizabalh@gmail.com' THEN '573205218908'
    WHEN 'fabianimacias81@gmail.com' THEN '573202216183'
    WHEN 'solcitysas@gmail.com' THEN '573124305684'
    WHEN 'adecorarbyamb@gmail.com' THEN '573128019812'
    WHEN 'novahubmk@gmail.com' THEN '573102099522'
    WHEN 'lopezarellanojuanfrancisco@gmail.com' THEN '523329318185'
    WHEN 'cristianspn5417@gmail.com' THEN '34614668085'
    WHEN 'candela-007@hotmail.com' THEN '573112497579'
    WHEN 'lauvaler665@gmail.com' THEN '573202961181'
    WHEN 'infomajestuosamk@gmail.com' THEN '34672603899'
    WHEN 'bjdazap@gmail.com' THEN '573103526645'
    WHEN 'rriveramaria@gmail.com' THEN '573113524085'
    WHEN 'alex-2027@hotmail.com' THEN '573205904145'
    ELSE buyer_phone END
WHERE buyer_email IN ('estevancartagena@gmail.com', 'villanica@gmail.com', 'liizlacruz@gmail.com', 'bexterfilms1518@gmail.com', 'rebecademonzon@yahoo.com.mx', 'klaudyaportes@gmail.com', 'zullihoyod@gmail.com', 'molinafabianarq@gmail.com', 'hallertirado@gmail.com', 'billonariolatino21k@gmail.com', 'alejandrolorenzl@hotmail.com', 'adnfitnessjujuy@gmail.com', 'dianamarcelarias@gmail.com', 'integralbodybeauty@gmail.com', 'danycaceresagnello@gmail.com', 'yenit_27@hotmail.com', 'ravellanedam@gmail.com', 'garciavasquezgabriel@gmail.com', 'natalia03625@gmail.com', 'cristiangzesc@gmail.com', 'acgamboan@gmail.com', 'colombianaautosales@gmail.com', 'sicaagustin2000@gmail.com', 'isabelsarca@gmail.com', 'juanybric@msn.com', 'melanievela43@gmail.com', 'nataliamorenocalle@gmail.com', 'julian.munozcruz@gmail.com', 'javier.vasquezpalacios@hotmail.com', 'lidumonasterio11@gmail.com', 'agenciainmobiliariacancun@gmail.com', 'fredy.gamarra.z@gmail.com', 'aponteyaz201701@gmail.com', 'sharikdnanda456@gmail.com', 'ivonnealfonso28@gmail.com', 'cajitamelosa@gmail.com', 'lesanabriaochoa@gmail.com', 'fabiansuperseya@gmail.com', 'alexander.koteskys@gmail.com', 'jom7215jom@gmail.com', 'karenarodriguezg@gmail.com', 'alexafreitez27@gmail.com', 'florencia@inuitlab.com', 'jose.viropa@gmail.com', 'rayquipa@hotmail.com', 'aryamfrigia@gmail.com', 'mariaalexandragk@gmail.com', 'nellyfloresegocheaga@gmail.com', 'majopillo09@gmail.com', 'redondo.paola@gmail.com', 'aylin.alfaror@gmail.com', 'denisseortiz35@gmail.com', 'imjoyasplata@gmail.com', 'paosinrumbo@gmail.com', 'lourdesvrealtor@gmail.com', 'wendybiflo@hotmail.com', 'lu2montene@gmail.com', 'edgarfaviani@gmail.com', 'mariaelcycardozomartinez@gmail.com', 'natalycreativa@hotmail.com', 'carfel42@hotmail.com', 'angie.silva.9807@gmail.com', 'mailithbustamante@gmail.com', 'saratuxtra@gmail.com', 'erita28_9@hotmail.com', 'vivi.galindo83@outlook.com', 'slpconstruction81@gmail.com', 'veronicacuartassuarez@gmail.com', 'joanna_amaral@live.com', 'khatebolivarugc@gmail.com', 'angie_0231@hotmail.com', 'claudiadelahoz@hotmail.com', 'jimematacin@gmail.com', 'paoaristizabal1@hotmail.com', 'mcamilams2022@gmail.com', 'rosarioochoa1102@gmail.com', 'dperfectos@hotmail.com', 'gilberto@gobemax.com', 'c.gerardomontalvo@gmail.com', 'spalzate@gmail.com', 'gsefair@gmail.com', 'crew@clandestinostudio.com', 'di.chiriboga@gmail.com', 'mauricioorjuela18@gmail.com', 'morios.oficial@gmail.com', 'fandosvictoria@gmail.com', '3amultiservicesllc@gmail.com', 'formacionfuturoglobal@gmail.com', 'johan.fuen@gmail.com', 'bronsillon90@hotmail.com', 'graphic.halland@gmail.com', 'bernallcarloss21@gmail.com', 'nydia_beltran@yahoo.com.mx', 'mariaaquije35@gmail.com', 'pau.cbe2530@gmail.com', 'luigi.alcalde@gmail.com', 'carlosjosuemz8@gmail.com', 'karennataliaflorez457@gmail.com', 'ramvaleria61@gmail.com', 'aldo@aldocivico.com', 'janissantaella@yahoo.com', 'jonavypiedrahita@gmail.com', 'elianapg9294@gmail.com', 'jorgeramirezdocenciadeportiva@gmail.com', 'realty.golden@gmail.com', 'rodriguez22_ashlee@hotmail.com', 'fabiobayonarios@gmail.com', 'monimerchan@gmail.com', 'julirolspper@gmail.com', 'jonathan.mrh@outlook.com', 'dpolania92@gmail.com', 'atomatizaciones.ctrl.v@gmail.com', 'mateolambisgomez9@gmail.com', 'julianarias502@gmail.com', 'paul_pb15@hotmail.com', 'latindjsoc@gmail.com', 'joseok86@gmail.com', 'dorothy.gonzalez@figoservices.com', 'rgonzalez@asesoriasglobales.cl', 'soyricardocastillo222@gmail.com', 'barradd@gmail.com', 'jans1609@gmail.com', 'topetelm@gmail.com', 'lcatalina.valencia@gmail.com', 'shantajo@hotmail.com', 'mishellecjg@hotmail.com', 'laura.bunge@icloud.com', 'jhonatan1993aaguilar@gmail.com', 'j4tzu3@gmail.com', 'manu.valladares90@gmail.com', 'maryohaa277@gmail.com', 'jorgelinadc@gmail.com', 'argesestudios@gmail.com', 'rosierod24@gmail.com', 'katyvilleg@gmail.com', 'oriettmarquez@hotmail.com', 'geinermedinalopez9@gmail.com', 'jbetts80@gmail.com', 'mariajosezamorano92@gmail.com', 'equiposoporteeyj@gmail.com', 'mohaalm57@gmail.com', 'yvanmr777@gmail.com', 'mario.szp27@gmail.com', 'alexasantysteban@hotmail.com', 'hbegazo@grupoissa.org', 'noheliaestrad@msn.com', 'yoli_gh@yahoo.com', 'academiahispanadepnl@gmail.com', 'johnyposada@hotmail.com', 'paolamembrillo@yahoo.com.mx', 'karlalar@gmail.com', 'nenis.posso@gmail.com', 'niurka.jovanovich.luza@gmail.com', 'garzon.gustavoa@gmail.com', 'kenyadiaz@gmail.com', 'canilla007@gmail.com', 'viwe.org@gmail.com', 'kerimparra@gmail.com', 'miguelmlemus@gmail.com', 'luisfelipe1213@gmail.com', 'luzgmay@gmail.com', 'maria.olavarri27@gmail.com', 'tatianaserna1209@gmail.com', 'danielpinillarojas@gmail.com', 'monarchoficial@gmail.com', 'yurgennyrosario@gmail.com', 'roberttolentopro@gmail.com', 'marcela3443.34@gmail.com', 'chiko228@gmail.com', 'lourdes14772@gmail.com', 'bgsaplicaciones@gmail.com', 'yisethbeltran2006@gmail.com', 'magima89@gmail.com', 'dratatianaceballos@gmail.com', 'gadn88@gmail.com', 'vcamargod2016@gmail.com', 'oscarjavierpizza@gmail.com', 'yeraldintriana09@gmail.com', 'manuelaepedesign@gmail.com', 'johanita.trusca@gmail.com', 'evaromeror@yahoo.com', 'hola@elalgo.co', 'vivian.andrea0131@gmail.com', 'tabaresarboleda@gmail.com', 'pabrilda7314@icloud.com', 'yeber32@gmail.com', 'verokar2008@gmail.com', 'maristizabalh@gmail.com', 'fabianimacias81@gmail.com', 'solcitysas@gmail.com', 'adecorarbyamb@gmail.com', 'novahubmk@gmail.com', 'lopezarellanojuanfrancisco@gmail.com', 'cristianspn5417@gmail.com', 'candela-007@hotmail.com', 'lauvaler665@gmail.com', 'infomajestuosamk@gmail.com', 'bjdazap@gmail.com', 'rriveramaria@gmail.com', 'alex-2027@hotmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

UPDATE transactions
  SET buyer_phone = CASE buyer_email
    WHEN 'carolinerojasb10@gmail.com' THEN '34652230622'
    WHEN 'salazarsanchezlinafernanda1@gmail.com' THEN '573168435067'
    WHEN 'cesarlozada300@gmail.com' THEN '593994681219'
    WHEN 'angie.chavez180497@gmail.com' THEN '5930991379955'
    WHEN 'luismiguel.aguirre17@gmail.com' THEN '573127130888'
    WHEN 'jareroluis@gmail.com' THEN '524761509858'
    WHEN 'jose0717k@gmail.com' THEN '573014410645'
    WHEN 'anamas06@hotmail.com' THEN '573151131504'
    WHEN 'digitalxpresscali@gmail.com' THEN '573216142097'
    WHEN 'doracaicedo71@gmail.com' THEN '13233989357'
    WHEN 'esther051996@gmail.com' THEN '573226624171'
    WHEN 'erickmonsalvev@gmail.com' THEN '112019899408'
    WHEN 'eloisa.arcos@globalbit.co' THEN '573163681382'
    WHEN 'gabamkd@gmail.com' THEN '34603011384'
    WHEN 'musico_118@hotmail.com' THEN '573133707065'
    WHEN 'kevinp96.kp@gmail.com' THEN '527223716048'
    WHEN 'caro.savet@gmail.com' THEN '573105600801'
    WHEN 'jonatan.traderfx@gmail.com' THEN '573242825045'
    WHEN 'mariamlopezmedina@gmail.com' THEN '573227685901'
    WHEN 'admonproteccionymas@gmail.com' THEN '573116136016'
    WHEN 'edward_27_05@hotmail.com' THEN '573102510381'
    WHEN 'mysmartlifeco@gmail.com' THEN '573105056637'
    WHEN 'nadiamulerogordillo@gmail.com' THEN '34610054967'
    WHEN 'andersoncruzdigital@gmail.com' THEN '51971882247'
    WHEN 'nel_and@hotmail.com' THEN '573012831960'
    WHEN 'jsanta82@hotmail.com' THEN '573156398490'
    WHEN 'estebanmejia.sdvsf@gmail.com' THEN '573245851651'
    WHEN 'sandraarbelaeztoro@gmail.com' THEN '573113288946'
    WHEN 'edwinneduardoreina@gmail.com' THEN '573132835396'
    WHEN 'damarisnailsexpert@gmail.com' THEN '573228559782'
    WHEN 'sofiapinzonramirez16@gmail.com' THEN '573144780028'
    WHEN 'kserna353@gmail.com' THEN '573204541986'
    WHEN 'bblandia17@gmail.com' THEN '50251898949'
    WHEN 'amastali2@gmail.com' THEN '573007852691'
    WHEN 'maleja2089@hotmail.com' THEN '573185540094'
    WHEN 'rmmagia@gmail.com' THEN '573502448421'
    WHEN 'monicamariagomez78@gmail.com' THEN '573023837564'
    WHEN 'sebastianmcsa77@gmail.com' THEN '573146705089'
    WHEN 's.caicedo.ocampo@gmail.com' THEN '573167506142'
    WHEN 'marcela0205@hotmail.com' THEN '573126244032'
    WHEN 'jvuc12@hotmail.com' THEN '573216073746'
    WHEN 'chispaandina@gmail.com' THEN '51945755057'
    WHEN 'conbar74@gmail.com' THEN '573246822478'
    ELSE buyer_phone END
WHERE buyer_email IN ('carolinerojasb10@gmail.com', 'salazarsanchezlinafernanda1@gmail.com', 'cesarlozada300@gmail.com', 'angie.chavez180497@gmail.com', 'luismiguel.aguirre17@gmail.com', 'jareroluis@gmail.com', 'jose0717k@gmail.com', 'anamas06@hotmail.com', 'digitalxpresscali@gmail.com', 'doracaicedo71@gmail.com', 'esther051996@gmail.com', 'erickmonsalvev@gmail.com', 'eloisa.arcos@globalbit.co', 'gabamkd@gmail.com', 'musico_118@hotmail.com', 'kevinp96.kp@gmail.com', 'caro.savet@gmail.com', 'jonatan.traderfx@gmail.com', 'mariamlopezmedina@gmail.com', 'admonproteccionymas@gmail.com', 'edward_27_05@hotmail.com', 'mysmartlifeco@gmail.com', 'nadiamulerogordillo@gmail.com', 'andersoncruzdigital@gmail.com', 'nel_and@hotmail.com', 'jsanta82@hotmail.com', 'estebanmejia.sdvsf@gmail.com', 'sandraarbelaeztoro@gmail.com', 'edwinneduardoreina@gmail.com', 'damarisnailsexpert@gmail.com', 'sofiapinzonramirez16@gmail.com', 'kserna353@gmail.com', 'bblandia17@gmail.com', 'amastali2@gmail.com', 'maleja2089@hotmail.com', 'rmmagia@gmail.com', 'monicamariagomez78@gmail.com', 'sebastianmcsa77@gmail.com', 's.caicedo.ocampo@gmail.com', 'marcela0205@hotmail.com', 'jvuc12@hotmail.com', 'chispaandina@gmail.com', 'conbar74@gmail.com')
  AND (buyer_phone IS NULL OR trim(buyer_phone) = '')
  AND plan_name != 'Reto 15D';

-- FIN — verificar con:
-- SELECT COUNT(*), status FROM transactions WHERE plan_name = 'Reto 15D' GROUP BY status;