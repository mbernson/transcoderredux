-- drop.applescript
-- ReduxZero
global filesize
global thequotedapppath
global imagesize
global backslash
global parts

-- The "drop" event handler is called when the appropriate type of data is dropped onto the object. All of the pertinent information about the drop is contained in the "dragInfo" object.
--
on drop theObject drag info dragInfo
	set theDataSource to (data source of table view "files" of scroll view "files" of window "ReduxZero")
	
	-- Get the list of data types on the pasteboard
	set dataTypes to types of pasteboard of dragInfo
	
	-- We are only interested in either "file names" or "color" data types
	if "file names" is in dataTypes then
		-- Initialize the list of files to an empty list
		set theFiles to {}
		
		-- We want the data as a list of file names, so set the preferred type to "file names"
		set preferred type of pasteboard of dragInfo to "file names"
		
		-- Get the list of files from the pasteboard
		set theFiles to contents of pasteboard of dragInfo
		
		-- Make sure we have at least one item
		if (count of theFiles) > 0 then
			--- Get the data source from the table view
			
			-- Turn off the updating of the views
			set update views of theDataSource to false
			
			-- Delete all of the data rows in the data source
			--		delete every data row of theDataSource
			
			-- For every item in the list, make a new data row and set it's contents
			set theFiles2 to ASCII_Sort(theFiles) as list
			repeat with theItem in theFiles2
				set theDataRow to make new data row at end of data rows of theDataSource
				set contents of data cell "files" of theDataRow to theItem
			end repeat
			
			-- Turn back on the updating of the views
			set update views of theDataSource to true
		end if
	end if
	-- Set the preferred type back to the default
	--	set preferred type of pasteboard of dragInfo to ""
	update window "ReduxZero"
	return true
end drop

on awake from nib theObject
	try
		update window "ReduxZero"
	end try
end awake from nib


on ASCII_Sort(my_list)
	set the index_list to {}
	set the sorted_list to {}
	--repeat with grr in my_list
	--	display dialog (count of items of my_list) as string
	repeat (count of items of my_list) times
		set the low_item to ""
		repeat with i from 1 to (count of items in my_list)
			if i is not in the index_list then
				set this_item to item i of my_list as text
				if the low_item is "" then
					set the low_item to this_item
					set the low_item_index to i
				else if this_item comes before the low_item then
					set the low_item to this_item
					set the low_item_index to i
				end if
			end if
		end repeat
		set the end of sorted_list to the low_item
		set the end of the index_list to the low_item_index
	end repeat
	return the sorted_list
end ASCII_Sort