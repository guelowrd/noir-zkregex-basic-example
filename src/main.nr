global MSG_BYTES_NUMBER = 24;
// global REVEAL_BYTES_NUMBER = 8;
// global GROUP_IDX = 1;
global STATES_NUM_COLS = 5;
global STATES_NUM_ROWS = 25; // = MSG_BYTES_NUMBER + 1;
global STATES_SIZE = 125; // = STATES_NUM_ROWS * STATES_NUM_COLS;

fn main(text_input: [Field; MSG_BYTES_NUMBER]) {
    let mut text_input_is_valid: bool = true;
    let mut states: [u1; STATES_SIZE] = [0; STATES_SIZE];
    // Initialize states' first row nd first column
    for i in 0..MSG_BYTES_NUMBER {
        states[i + 0*STATES_NUM_ROWS] = 1;
    }
    // for i in 1..STATES_NUM_COLS {
    //     states[0 + i*STATES_NUM_ROWS] = 0;
    // }
    // Compute fullfillment of all states for each character input
    for i in 0..MSG_BYTES_NUMBER {
        // State 1 fulfilled if 
        // previous state is 0 and character input is "N"
        states[(i + 1) + 1*STATES_NUM_ROWS] = states[i + 0*STATES_NUM_ROWS] & ((text_input[i] == 78) as u1);

        // State 2 fulfilled if
        // previous state is 1 and character input is "o"
        states[(i + 1) + 2*STATES_NUM_ROWS] = states[i + 1*STATES_NUM_ROWS] & ((text_input[i] == 111) as u1);

        // State 3 fulfilled if 
        // previous state is 2 and character input is "i"
        // or previous state is 3 and character input is "I" or "i"
        states[(i + 1) + 3*STATES_NUM_ROWS] = (states[i + 2*STATES_NUM_ROWS] & ((text_input[i] == 105) as u1)) | (states[i + 2*STATES_NUM_ROWS] & ((text_input[i] == 105) as u1 | (text_input[i] == 73) as u1));
        
        // State 4 fulfilled if 
        // previous state is 3 and character input is "r"
        states[(i + 1) + 4*STATES_NUM_ROWS] = states[i + 3*STATES_NUM_ROWS] & ((text_input[i] == 114) as u1);

        /////////////// TO REMOVE ///////////////
        if text_input[i] as u8 > 127 {
            text_input_is_valid = false;
        }
        /////////////// TO REMOVE ///////////////
    }
    let mut final_state_sum: [u8; STATES_NUM_ROWS] = [0; STATES_NUM_ROWS];
    final_state_sum[0] = states[0 + (STATES_NUM_COLS - 1)*STATES_NUM_ROWS] as u8;
    for i in 1..STATES_NUM_ROWS {
        final_state_sum[i] = final_state_sum[i-1] + states[i + (STATES_NUM_COLS - 1)*STATES_NUM_ROWS] as u8;
    }
    let entire_count = final_state_sum[MSG_BYTES_NUMBER];

    assert(text_input_is_valid);
    assert(entire_count > 0);
}

// fn regex(text_input: [Field; MSG_BYTES_NUMBER], match_index: pub Field) -> (Field, Field, Field, [Field; REVEALED_BYTES_NUMBER]) { // (start_idx: Field, group_match_count: Field, entire_count: Field, text_revealed: [Field; REVEALED_BYTES_NUMBER])

// }

#[test]
fn test_main() {
    let x: [Field; MSG_BYTES_NUMBER] = [78, 111, 105, 114, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    main(x);
}
