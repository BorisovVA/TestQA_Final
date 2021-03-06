#language: ru

@tree

Функционал: Проверка дкоумента расход товаров

Как Менеджер по продажам я хочу
оформлять реализацию товаров
чтобы получать зарплату)

Контекст:
	Дано Я запускаю сценарий открытия TestClient или подключаю уже существующий


Сценарий: _0301 Подготовительный этап
	Когда Экспорт основных данных
	Когда Загрузка поступления товаров
	И я выполняю код встроенного языка на сервере
		|'Документы.ПриходТовара.НайтиПоНомеру("000000051").ПолучитьОбъект().Записать(РежимЗаписиДокумента.Проведение);'|

Сценарий: _0302 Создание документа Расход товара
	* Заполнение шапки документа
		И В командном интерфейсе я выбираю 'Продажи' 'Документы продаж'
		И я нажимаю на кнопку с именем 'ФормаСоздатьПоПараметруРасходТовара'
		И из выпадающего списка с именем "Организация" я выбираю точное значение 'ООО "Товары"'
		И я нажимаю кнопку выбора у поля с именем "Покупатель"
		И я нажимаю на кнопку с именем 'ФормаСписок'
		И в таблице "Список" я перехожу к строке:
			| 'Код'       | 'Наименование'              |
			| '000000014' | 'Магазин "Бытовая техника"' |
		И в таблице "Список" я выбираю текущую строку
		И из выпадающего списка с именем "Склад" я выбираю точное значение 'Средний'
		И из выпадающего списка с именем "Валюта" я выбираю точное значение 'Рубли'
	* Заполнение табличной части
		И в таблице "Товары" я нажимаю на кнопку с именем 'ТоварыДобавить'
		И в таблице "Товары" я нажимаю кнопку выбора у реквизита с именем "ТоварыТовар"
		И в таблице "Список" я перехожу к строке по шаблону:
			| 'Артикул'   | 'Код'       | 'Количество' | 'Наименование' |
			| 'VEKO00001' | '000000028' | '*'          | 'Veko345MO'    |
		И в таблице "Список" я выбираю текущую строку
		И в таблице "Товары" я завершаю редактирование строки
	* Проведение документа
		И я нажимаю на кнопку с именем 'ФормаПровести'
		И я запоминаю значение поля "Номер" как "НомерДокумента"
		И я закрываю все окна клиентского приложения

	
	
Сценарий: _0303 Проверка движений документа
	* Подготовка
		И я закрываю все окна клиентского приложения
		И Я открываю навигационную ссылку "e1cib/list/ЖурналДокументов.ДокументыПродаж"
		И в таблице "Список" я перехожу к строке:
			| 'Номер'     | 'Организация'  | 'Тип документа' | 'Покупатель'                | 'Склад'   | 'Валюта' | 'Вид цен'      | 'Состояние заказа' |
			| '000000001' | 'ООО "Товары"' | 'Продажа'       | 'Магазин "Бытовая техника"' | 'Средний' | 'Рубли'  | 'Мелкооптовая' | ''                 |
		И в таблице "Список" я выбираю текущую строку
	* Проверка движения по регистру Взаиморасчетов
		И В текущем окне я нажимаю кнопку командного интерфейса 'Регистр взаиморасчетов с контрагентами'
		Тогда таблица "Список" стала равной по шаблону:
			| 'Период' | 'Регистратор'            | 'Номер строки' | 'Контрагент'                | 'Сумма'     | 'Валюта' |
			| '*'      | 'Продажа 000000001 от *' | '1'            | 'Магазин "Бытовая техника"' | '17 500,00' | 'Рубли'  |
	
	* Проверка движений по регистру продаж
		И В текущем окне я нажимаю кнопку командного интерфейса 'Регистр продаж'
		Тогда таблица "Список" стала равной по шаблону:
			| 'Период' | 'Регистратор'            | 'Номер строки' | 'Покупатель'                | 'Сумма'     | 'Товар'     | 'Количество' |
			| '*'      | 'Продажа 000000001 от *' | '1'            | 'Магазин "Бытовая техника"' | '17 500,00' | 'Veko345MO' | '1,00'       |
				
	* Проверка движений по регистру товарных запасов
		И В текущем окне я нажимаю кнопку командного интерфейса 'Регистр товарных запасов'
		Тогда таблица "Список" стала равной по шаблону:
			| 'Период' | 'Регистратор'            | 'Номер строки' | 'Склад'   | 'Товар'     | 'Количество' |
			| '*'      | 'Продажа 000000001 от *' | '1'            | 'Средний' | 'Veko345MO' | '1,00'       |
		И я закрываю все окна клиентского приложения
		
Сценарий: _0304 Проверка печатной формы Расходная накладная
		* Подготовка
			И я закрываю все окна клиентского приложения
			И Я открываю навигационную ссылку "e1cib/list/ЖурналДокументов.ДокументыПродаж"
			И в таблице "Список" я перехожу к строке:
				| 'Номер'     | 'Организация'  | 'Тип документа' | 'Покупатель'                | 'Склад'   | 'Валюта' | 'Вид цен'      | 'Состояние заказа' |
				| '000000001' | 'ООО "Товары"' | 'Продажа'       | 'Магазин "Бытовая техника"' | 'Средний' | 'Рубли'  | 'Мелкооптовая' | ''                 |
			И в таблице "Список" я выбираю текущую строку
		* Проверка печатной формы
			И я нажимаю на кнопку с именем 'ФормаДокументРасходТовараПечатьРасходнойНакладной'
			Тогда табличный документ "SpreadsheetDocument" содержит строки по шаблону:
				| 'Расход товара' | ''                                                | ''           | ''       |
				| ''              | ''                                                | ''           | ''       |
				| 'Номер'         | '*'                                               | ''           | ''       |
				| 'Дата'          | '*'                                               | ''           | ''       |
				| 'Покупатель'    | 'Магазин "Бытовая техника"'                       | ''           | ''       |
				| 'Склад'         | 'Средний'                                         | ''           | ''       |
				| 'Сумма'         | '17 500 рублей (Семнадцать тысяч пятьсот рублей)' | ''           | ''       |
				| ''              | ''                                                | ''           | ''       |
				| 'Товар'         | 'Цена'                                            | 'Количество' | 'Сумма'  |
				| 'Veko345MO'     | '17 500'                                          | '1'          | '17 500' |
			И я закрываю все окна клиентского приложения		
							
Сценарий: _0305 Проверка печатной формы Доставка
		* Подготовка
			И я закрываю все окна клиентского приложения
			И Я открываю навигационную ссылку "e1cib/list/ЖурналДокументов.ДокументыПродаж"
			И в таблице "Список" я перехожу к строке:
				| 'Номер'     | 'Организация'  | 'Тип документа' | 'Покупатель'                | 'Склад'   | 'Валюта' | 'Вид цен'      | 'Состояние заказа' |
				| '000000001' | 'ООО "Товары"' | 'Продажа'       | 'Магазин "Бытовая техника"' | 'Средний' | 'Рубли'  | 'Мелкооптовая' | ''                 |
			И в таблице "Список" я выбираю текущую строку
		* Проверка печатной формы Доставки
			И я нажимаю на кнопку с именем 'ФормаОформитьДоставку'
			И в табличном документе 'ТабличныйДокумент' я перехожу к ячейке "Адрес"
			И в табличном документе 'ТабличныйДокумент' я делаю двойной клик на текущей ячейке
			И в табличный документ "ТабличныйДокумент" я ввожу текст 'Адрес доставки'
			И в табличном документе 'ТабличныйДокумент' я перехожу к ячейке "СрокДоставки"
			И в табличном документе 'ТабличныйДокумент' я делаю двойной клик на текущей ячейке
			И в табличный документ "ТабличныйДокумент" я ввожу текст '21'
			И я закрываю все окна клиентского приложения
	
						
				
				
				