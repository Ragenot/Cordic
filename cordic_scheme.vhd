library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library xil_defaultlib;
use xil_defaultlib.Core.all;
--use IEEE.NUMERIC_STD.ALL;

entity Cordic_scheme is
    generic(N: integer := 16);
    port(
        clk: in std_logic;
        fsm_control_signals: in std_logic_vector(2 downto 0);
        input_angle, x, y: in std_logic_vector(N-1 downto 0);
        tan_addr: in std_logic_vector(2 downto 0);
        result_x, result_y: out std_logic_vector(N-1 downto 0)
        );
end;

architecture struct of Cordic_scheme is
    component multiplication_scheme is
        generic(N: integer := 16);
        port(
            x, y: in std_logic_vector(N-1 downto 0);
            mode: in std_logic;
            shift: in std_logic_vector(2 downto 0);
            new_x, new_y: out std_logic_vector(N-1 downto 0)
            );
    end component ;
    component cordic_tan_rom is
        generic (N: integer := 16);
        port(
            addr: in  std_logic_vector(2 downto 0); 
            data: out std_logic_vector(N-1 downto 0)
            );
    end component;
    component Greater_then is
        generic(N: integer := 16);
        port(
            a, b: in std_logic_vector(N-1 downto 0);
            isGreater: out std_logic
            );
    end component;
    component accumulator is
        port(
            clk, rst: in std_logic;
            en : in std_logic; 
            reg_in : in std_logic_vector(15 downto 0);
            reg_out: out std_logic_vector(15 downto 0)
            );
    end component;
    component accumulator_2_in is
        port(
            clk, rst: in std_logic;
            en_1, en_2 : in std_logic; 
            reg_in_1, reg_in_2 : in std_logic_vector(15 downto 0);
            reg_out: out std_logic_vector(15 downto 0)
            );
    end component;
    component add_sub is 
        port(
            a : in std_logic_vector (15 downto 0); 
            b : in std_logic_vector (15 downto 0); 
            mode : in std_logic; 
            c : out std_logic_vector (15 downto 0)
            ); 
    end component;
    component scaler is
        generic(N: integer := 16);
        port(
            x, y: in std_logic_vector(N-1 downto 0);
            new_x, new_y: out std_logic_vector(N-1 downto 0)
            );
    end component;
    constant const_0_pi  : std_logic_vector(N-1 downto 0) := "0000000000000000"; 
    constant const_pi_2  : std_logic_vector(N-1 downto 0) := "0001100100100010";
    constant const_pi    : std_logic_vector(N-1 downto 0) := "0011001001000100";
    constant const_3_pi_2: std_logic_vector(N-1 downto 0) := "0100101101100110";
    constant const_2_pi  : std_logic_vector(N-1 downto 0) := "0110010010001000";
    
    signal greater_then_vector: std_logic_vector(2 downto 0);
    signal compare_vector: std_logic_vector(4 downto 0);
    signal tangent_output, add_sub_output, angle_acc_output: std_logic_vector(N-1 downto 0);
    signal normalized_angle, normalized_x, normalized_y: std_logic_vector(N-1 downto 0);
    signal mul_x_output, mul_y_output, x_output, y_output: std_logic_vector(N-1 downto 0);
    signal mode: std_logic;
    --output from fsm
    signal global_reset, angle_en, mul_en: std_logic;
begin

    (mul_en, angle_en, global_reset) <= fsm_control_signals;

    pre_processing(
        input_angle => input_angle,
        x => x,
        y => y, 
		normalized_angle => normalized_angle,
		normalized_x => normalized_x,
        normalized_y => normalized_y
    );
    
--    scaling(
--        x => x_output,
--        y => y_output,
--        scaled_x => result_x,
--        scaled_y => result_y    
--    );
    
    TAN_COEF: cordic_tan_rom port map(
        addr => tan_addr, 
        data => tangent_output
    );

    Coordinate_1: accumulator_2_in port map(
        clk => clk, 
        rst => '0', 
        en_1 => global_reset, 
        en_2 => mul_en, 
        reg_in_1 => normalized_x, 
        reg_in_2 => mul_x_output, 
        reg_out => x_output
    );
    
    Coordinate_2: accumulator_2_in port map(
        clk => clk, 
        rst => '0', 
        en_1 => global_reset, 
        en_2 => mul_en, 
        reg_in_1 => normalized_y, 
        reg_in_2 => mul_y_output, 
        reg_out => y_output
    );
    
    ANGLE_ACC: accumulator port map(
        clk => clk, 
        rst => global_reset, 
        en => angle_en, 
        reg_in => add_sub_output, 
        reg_out => angle_acc_output
    );
    
    CMP_MODE: Greater_then port map(
        a => normalized_angle, 
        b => angle_acc_output, 
        isGreater => mode
    );
    
    MUL: multiplication_scheme port map(
        x => x_output,
        y => y_output, 
        mode => mode, 
        shift => tan_addr, 
        new_x => mul_x_output, 
        new_y => mul_y_output
    );
    
    ANGLE_ADD_SUB: add_sub port map(
        a => angle_acc_output, 
        b => tangent_output, 
        mode => mode, 
        c => add_sub_output
    );
    
    SCALE: scaler port map(
        x => x_output,
        y => y_output,  
        new_x => result_x, 
        new_y => result_y
    );
    --result_x <= x_output;
    --result_y <= y_output;
    
end;